import Foundation
import Combine

import Networking
import Model
import Common

final class CommunityViewModel: BaseViewModel {
    struct Input {
        let firstLoad = PassthroughSubject<Void, Never>()
        let didTapPollCategoryButton = PassthroughSubject<Void, Never>()
        let didSelectPollItem = PassthroughSubject<String, Never>()
        let didTapDistrictButton = PassthroughSubject<Void, Never>()
        let didSelect = PassthroughSubject<IndexPath, Never>()
    }

    struct Output {
        let showLoading = PassthroughSubject<Bool, Never>()
        let showToast = PassthroughSubject<String, Never>()
        let route = PassthroughSubject<Route, Never>()
        let sections = CurrentValueSubject<[CommunitySection], Never>([])
        let updatePopularStores = PassthroughSubject<Void, Never>()
        let showErrorAlert = PassthroughSubject<Error, Never>()
    }

    struct State {
        let storeList = CurrentValueSubject<[PlatformStore], Never>([])
        let reload = PassthroughSubject<Void, Never>()
        let currentStoreTab = CurrentValueSubject<CommunityPopularStoreTab, Never>(.defaultTab)
    }

    enum Route {
        case pollCategoryTab(PollCategoryTabViewModel)
        case pollDetail(PollDetailViewModel)
        case popularStoreNeighborhoods(CommunityPopularStoreNeighborhoodsViewModel)
        case storeDetail(Int)
        case bossStoreDetail(String)
    }

    let input = Input()
    let output = Output()

    private var state = State()

    private let communityService: CommunityServiceProtocol
    private let userDefaultsUtil: UserDefaultsUtil

    private lazy var pollListCellViewModel = bindPollListCellViewModel()

    init(
        communityService: CommunityServiceProtocol = CommunityService(),
        userDefaultsUtil: UserDefaultsUtil = .shared
    ) {
        self.communityService = communityService
        self.userDefaultsUtil = userDefaultsUtil

        super.init()
    }

    override func bind() {
        super.bind()

        input.firstLoad
            .merge(with: state.reload)
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, _ in
                owner.output.showLoading.send(true)
            })
            .map { (owner: CommunityViewModel, _: Void) in
                return FetchPopularStoresInput(
                    criteria: owner.state.currentStoreTab.value.rawValue,
                    district: owner.userDefaultsUtil.communityPopularStoreNeighborhoods.district
                )
            }
            .withUnretained(self)
            .asyncMap { owner, input in
                await owner.communityService.fetchPopularStores(input: input)
            }
            .withUnretained(self)
            .sink { owner, result in
                owner.output.showLoading.send(false)
                switch result {
                case .success(let response):
                    owner.state.storeList.send(response.contents.map {
                        PlatformStore(response: $0)
                    })
                    if response.contents.isEmpty {
                        owner.output.showToast.send("데이터가 없어요!")
                    }
                    owner.reloadDataSource()
                case .failure(let error):
                    owner.output.showToast.send(error.localizedDescription)
                }
            }
            .store(in: &cancellables)

        input.didSelect
            .withUnretained(self)
            .sink { owner, indexPath in
                let item = owner.output.sections.value[safe: indexPath.section]?.items[safe: indexPath.item]
                if case .popularStore(let store) = item, let id = Int(store.id) {
                    switch store.storeCategory {
                    case .bossStore:
                        owner.output.route.send(.bossStoreDetail(store.id))
                    case .userStore:
                        owner.output.route.send(.storeDetail(id))
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func reloadDataSource() {
        var sectionItems: [CommunitySectionItem] = []

        sectionItems.append(.poll(pollListCellViewModel))
        sectionItems.append(.popularStoreTab(bindPopularStoreTabCellViewModel()))

        sectionItems.append(contentsOf: state.storeList.value.map {
            .popularStore($0)
        })

        output.sections.send([
            CommunitySection(items: sectionItems)
        ])
    }

    private func bindPopularStoreTabCellViewModel() -> CommunityPopularStoreTabCellViewModel {
        let cellViewModel = CommunityPopularStoreTabCellViewModel(tab: state.currentStoreTab.value)

        cellViewModel.output.didTapDistrictButton
            .withUnretained(self)
            .map { owner, _ in
                return .popularStoreNeighborhoods(owner.bindPopularStoreNeighborhoodsViewModel())
            }
            .subscribe(output.route)
            .store(in: &cancellables)

        cellViewModel.output.currentTab
            .dropFirst()
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, tab in
                owner.state.currentStoreTab.send(tab)
                owner.state.reload.send()
            }
            .store(in: &cancellables)

        return cellViewModel
    }

    private func bindPopularStoreNeighborhoodsViewModel() -> CommunityPopularStoreNeighborhoodsViewModel {
        let viewModel = CommunityPopularStoreNeighborhoodsViewModel()

        viewModel.output.updatePopularStores
            .subscribe(output.updatePopularStores)
            .store(in: &cancellables)

        viewModel.output.updatePopularStores
            .subscribe(state.reload)
            .store(in: &cancellables)

        return viewModel
    }

    private func bindPollListCellViewModel() -> CommunityPollListCellViewModel {
        let cellViewModel = CommunityPollListCellViewModel()

        cellViewModel.output.didSelectCategory
            .withUnretained(self)
            .map { owner, _ in .pollCategoryTab(owner.bindPollCategoryTabViewModel()) }
            .subscribe(output.route)
            .store(in: &cancellables)

        cellViewModel.output.didSelectPollItem
            .map { pollId in
                .pollDetail(PollDetailViewModel(pollId: pollId))
            }
            .subscribe(output.route)
            .store(in: &cancellables)
        
        cellViewModel.output.showErrorAlert
            .subscribe(output.showErrorAlert)
            .store(in: &cancellables)

        return cellViewModel
    }

    private func bindPollCategoryTabViewModel() -> PollCategoryTabViewModel {
        let viewModel = PollCategoryTabViewModel()

        viewModel.output.updatePollList
            .subscribe(pollListCellViewModel.input.reload)
            .store(in: &cancellables)

        return viewModel
    }
}
