import Foundation
import Combine

import Common
import Networking
import Model

final class StoreDetailViewModel: BaseViewModel {
    struct Input {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let didTapDelete = PassthroughSubject<Void, Never>()
        
        // Overview section
        let didTapSave = PassthroughSubject<Void, Never>()
        let didTapShare = PassthroughSubject<Void, Never>()
        let didTapNavigation = PassthroughSubject<Void, Never>()
        let didTapWriteReview = PassthroughSubject<Void, Never>()
        
        let didTapShowMoreMenu = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let sections = PassthroughSubject<[StoreDetailSection], Never>()
        
        // Overview section
        let isFavorited = PassthroughSubject<Bool, Never>()
        let subscribersCount = PassthroughSubject<Int, Never>()
        
        
        let toast = PassthroughSubject<String, Never>()
        let error = PassthroughSubject<Error, Never>()
    }
    
    struct State {
        let storeId: Int
        let storeType: StoreType = .userStore
        var storeDetailData: StoreDetailData?
    }
    
    let input = Input()
    let output = Output()
    var state: State
    private let storeService: StoreServiceProtocol
    private let userDefaults: UserDefaultsUtil
    
    init(
        storeId: Int,
        storeService: StoreServiceProtocol = StoreService(),
        userDefaults: UserDefaultsUtil = .shared
    ) {
        self.state = State(storeId: storeId)
        self.storeService = storeService
        self.userDefaults = userDefaults
        
        super.init()
    }
    
    override func bind() {
        bindOverviewSection()
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { (owner: StoreDetailViewModel, _: Void) in
                owner.fetchStoreDetail()
            }
            .store(in: &cancellables)
    }
    
    private func bindOverviewSection() {
        input.didTapSave
            .withUnretained(self)
            .sink { (owner: StoreDetailViewModel, _) in
                let isDeleted = owner.state.storeDetailData?.overview.isFavorited == true
                owner.saveStore(isDelete: isDeleted)
            }
            .store(in: &cancellables)
    }
    
    private func fetchStoreDetail() {
        Task { [weak self] in
            guard let self else { return }
            
            let input = FetchStoreDetailInput(
                storeId: state.storeId,
                latitude: userDefaults.userCurrentLocation.coordinate.latitude,
                longitude: userDefaults.userCurrentLocation.coordinate.longitude
            )
            let storeDetailResult = await storeService.fetchStoreDetail(input: input)
            
            switch storeDetailResult {
            case .success(let response):
                let storeDetailData = StoreDetailData(response: response)
                let photoCount = response.images.cursor.totalCount
                let reviewCount = response.reviews.cursor.totalCount
                
                state.storeDetailData = storeDetailData
                
                output.sections.send([
                    .overviewSection(createOverviewCellViewModel(storeDetailData.overview)),
                    .visitSection(storeDetailData.visit),
                    .infoSection(
                        updatedAt: "2023.02.04 업데이트",
                        info: storeDetailData.info,
                        menuCellViewModel: createMenuCellViewModel(storeDetailData)
                    ),
                    .photoSection(totalCount: photoCount, photos: storeDetailData.photos),
                    .reviewSection(
                        totalCount: reviewCount,
                        rating: storeDetailData.rating,
                        reviews: storeDetailData.reviews
                    )
                ])
                
                output.isFavorited.send(response.favorite.isFavorite)
            case .failure(let failure):
                print("💜error: \(failure)")
            }
        }
    }
    
    private func createOverviewCellViewModel(_ data: StoreDetailOverview) -> StoreDetailOverviewCellViewModel {
        let config = StoreDetailOverviewCellViewModel.Config(overview: data)
        let viewModel = StoreDetailOverviewCellViewModel(config: config)
        
        viewModel.output.didTapFavorite
            .subscribe(input.didTapSave)
            .store(in: &cancellables)
        
        viewModel.output.didTapShare
            .subscribe(input.didTapShare)
            .store(in: &cancellables)
        
        viewModel.output.didTapNavigation
            .subscribe(input.didTapNavigation)
            .store(in: &cancellables)
        
        viewModel.output.didTapWriteReview
            .subscribe(input.didTapWriteReview)
            .store(in: &cancellables)
        
        output.isFavorited
            .subscribe(viewModel.input.isFavorited)
            .store(in: &cancellables)
        
        output.subscribersCount
            .subscribe(viewModel.input.subscribersCount)
            .store(in: &cancellables)
        
        return viewModel
    }
    
    private func createMenuCellViewModel(_ data: StoreDetailData) -> StoreDetailMenuCellViewModel {
        let config = StoreDetailMenuCellViewModel.Config(menus: data.menus, isShowAll: false)
        let viewModel = StoreDetailMenuCellViewModel(config: config)
        
        viewModel.output.didTapMore
            .subscribe(input.didTapShowMoreMenu)
            .store(in: &cancellables)
        
        return viewModel
    }
    
    private func saveStore(isDelete: Bool) {
        Task {
            let saveResult = await storeService.saveStore(
                storeType: state.storeType,
                storeId: String(state.storeId),
                isDelete: isDelete
            )
            
            switch saveResult {
            case .success(_):
                if isDelete {
                    state.storeDetailData?.overview.isFavorited = false
                    state.storeDetailData?.overview.subscribersCount -= 1
                    output.isFavorited.send(false)
                    output.toast.send(Strings.StoreDetail.Toast.addFavorite)
                } else {
                    state.storeDetailData?.overview.isFavorited = true
                    state.storeDetailData?.overview.subscribersCount += 1
                    output.isFavorited.send(true)
                    output.toast.send(Strings.StoreDetail.Toast.removeFavorite)
                }
                output.subscribersCount.send(state.storeDetailData?.overview.subscribersCount ?? 0)
                
            case .failure(let error):
                output.error.send(error)
            }
        }
    }
}
