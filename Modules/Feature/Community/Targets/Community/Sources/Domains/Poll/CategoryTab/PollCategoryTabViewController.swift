import UIKit
import Combine

import DesignSystem
import Common

final class PollCategoryTabViewController: BaseViewController {

    private let navigationBar = CommunityNavigationBar(title: "맛대맛 투표")
    private let tabView = CommunityTabView(titles: ["실시간 참여순", "최신순"])
    private let lineView: UIView = UIView().then {
        $0.backgroundColor = Colors.gray20.color
    }
    private let pageContainerView = UIView()
    private let pageViewController = BasePageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    private var pageContentViewControllers: [PollListViewController] = []
    private let createPollButton = UIButton().then {
        $0.backgroundColor = Colors.mainRed.color
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        $0.contentEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        $0.titleLabel?.font = Fonts.semiBold.font(size: 14)
        $0.setTitle("투표 만들기 0/1회", for: .normal)
        $0.setTitleColor(Colors.systemWhite.color, for: .normal)
        $0.setImage(Icons.fireSolid.image
            .resizeImage(scaledTo: 20)
            .withTintColor(Colors.systemWhite.color), for: .normal)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 8, height: 8)
        $0.layer.shadowOpacity = 0.1
    }

    private let viewModel: PollCategoryTabViewModel

    init(viewModel: PollCategoryTabViewModel = .init()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        viewModel.input.firstLoad.send()
    }

    private func setupUI() {
        view.backgroundColor = Colors.gray0.color

        view.addSubViews([
            navigationBar,
            lineView,
            tabView,
            createPollButton
        ])

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        tabView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabView)
            $0.height.equalTo(1)
        }

        createPollButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }

        setupPageViewController()

        view.bringSubviewToFront(createPollButton)
    }

    private func setupPageViewController() {
        addChild(pageViewController)
        pageContainerView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        view.addSubview(pageContainerView)
        pageContainerView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func changePage(to index: Int) {
        guard let viewController = pageContentViewControllers[safe: index] else { return }

        var direction: UIPageViewController.NavigationDirection = .forward
        let currentIndex = pageContentViewControllers.firstIndex(where: {
            $0 == pageViewController.viewControllers?.first
        })

        if let currentIndex, index < currentIndex {
            direction = .reverse
        }

        pageViewController.setViewControllers(
            [viewController],
            direction: direction,
            animated: true
        )
    }

    override func bindEvent() {
        super.bindEvent()

        tabView.didTap
            .main
            .withUnretained(self)
            .sink { owner, index in
                owner.changePage(to: index)
            }
            .store(in: &cancellables)

        navigationBar.backButton
            .controlPublisher(for: .touchUpInside)
            .main
            .withUnretained(self)
            .sink { owner, index in
                owner.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        // Input
        createPollButton
            .controlPublisher(for: .touchUpInside)
            .mapVoid
            .subscribe(viewModel.input.didTapCreatePollButton)
            .store(in: &cancellables)

        // Output
        viewModel.output.tabList
            .withUnretained(self)
            .main
            .sink { owner, tabList in
                owner.pageContentViewControllers = tabList.map {
                    PollListViewController(viewModel: $0)
                }
                owner.changePage(to: .zero)
            }
            .store(in: &cancellables)

        viewModel.output.createPollButtonTitle
            .main
            .withUnretained(self)
            .sink { owner, title in
                owner.createPollButton.setTitle(title, for: .normal)
            }
            .store(in: &cancellables)

        viewModel.output.isEnabledCreatePollButton
            .main
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, isEnabled in
                owner.createPollButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)

        viewModel.output.route
            .main
            .withUnretained(self)
            .sink { owner, route in
                switch route {
                case .createPoll(let viewModel):
                    let vc = CreatePollModalViewController(viewModel: viewModel)
                    owner.present(vc, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UIPageViewControllerDataSource
extension PollCategoryTabViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageContentViewControllers.firstIndex(where: { $0 == viewController }) else { return nil }

        return pageContentViewControllers[safe: index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageContentViewControllers.firstIndex(where: { $0 == viewController }) else { return nil }

        return pageContentViewControllers[safe: index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension PollCategoryTabViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let changedViewController = pageViewController.viewControllers?.first as? PollListViewController,
              let changedIndex = pageContentViewControllers.firstIndex(of: changedViewController) else { return }

        tabView.updateSelect(changedIndex)
    }
}