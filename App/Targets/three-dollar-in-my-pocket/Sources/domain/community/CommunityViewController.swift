import UIKit

import Model
import DesignSystem

final class CommunityViewController: BaseViewController {

    private let communityView = CommunityView()
    private let viewModel = CommunityViewModel()
    private lazy var dataSource = CommunityDataSource(
        collectionView: communityView.collectionView,
        viewModel: viewModel
    )

    init() {
        super.init(nibName: nil, bundle: nil)

        tabBarItem = UITabBarItem(title: nil, image: DesignSystemAsset.Icons.communitySolid.image, tag: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public static func instance() -> UINavigationController {
        let viewController = CommunityViewController()

        return UINavigationController(rootViewController: viewController).then {
            $0.isNavigationBarHidden = true
            $0.interactivePopGestureRecognizer?.delegate = nil
        }
    }

    override func loadView() {
        super.loadView()

        view = communityView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        communityView.collectionView.delegate = self

        dataSource.reloadData()
    }

    override func bindEvent() {
        super.bindEvent()

        viewModel.output.route
            .main
            .withUnretained(self)
            .sink { owner, route in
                switch route {
                case .poll:
                    let vc = CommunityPollTabViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource.itemIdentifier(for: indexPath) {
        case .poll:
            return CommunityPollListCell.Layout.size
        case .store:
            return CommunityStoreTabCell.Layout.size
        default:
            return .zero
        }
    }
}
