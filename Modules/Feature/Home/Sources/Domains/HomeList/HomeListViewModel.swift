import Foundation
import Combine
import CoreLocation

import Networking
import Common

final class HomeListViewModel: BaseViewModel {
    struct Input {
        let willDisplay = PassthroughSubject<Int, Never>()
        let onTapCategoryFilter = PassthroughSubject<Void, Never>()
        let selectCategory = PassthroughSubject<PlatformStoreCategory?, Never>()
        let onToggleCertifiedStore = PassthroughSubject<Void, Never>()
        let onToggleSort = PassthroughSubject<StoreSortType, Never>()
        let onTapOnlyBoss = PassthroughSubject<Void, Never>()
        let onTapStore = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        let categoryFilter = PassthroughSubject<PlatformStoreCategory?, Never>()
        let stores = PassthroughSubject<[StoreCard], Never>()
//        let advertisement = PassthroughSubject<Advertisement
        let route = PassthroughSubject<Route, Never>()
    }
    
    struct State {
        var categoryFilter: PlatformStoreCategory?
        var sortType: StoreSortType = .distanceAsc
        var isOnlyBossStore = false
        var isOnleyCertifiedStore = false
        var mapLocation: CLLocation
        let currentLocation: CLLocation
        var stores: [StoreCard] = []
        var nextCursor: String? = nil
        var hasMore: Bool = true
        let mapMaxDistance: Double?
    }
    
    enum Route {
        case pushStoreDetail(storeId: String)
        case showErrorAlert(Error)
        case presentCategoryFilter(PlatformStoreCategory?)
    }
    
    let input = Input()
    let output = Output()
    private var state: State
    private let storeService: StoreServiceProtocol
    
    init(state: State, storeService: StoreServiceProtocol) {
        self.state = state
        self.storeService = storeService
        super.init()
    }
    
    override func bind() {
        input.willDisplay
            .withUnretained(self)
            .filter { owner, index in
                owner.canLoad(index: index)
            }
            .asyncMap { owner, _ in
                await owner.fetchAroundStore()
            }
            .withUnretained(self)
            .sink { owner, result in
                switch result {
                case .success(let storeCards):
                    owner.state.stores += storeCards
                    
                case .failure(let error):
                    owner.output.route.send(.showErrorAlert(error))
                }
            }
            .store(in: &cancellables)
        
        input.onTapCategoryFilter
            .withUnretained(self)
            .sink { owner, _ in
                let currentCategory = owner.state.categoryFilter
                
                owner.output.route.send(.presentCategoryFilter(currentCategory))
            }
            .store(in: &cancellables)
        
        input.selectCategory
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, category in
                owner.state.hasMore = true
                owner.state.nextCursor = nil
                owner.state.stores = []
                owner.state.categoryFilter = category
            })
            .asyncMap { owner, _ in
                await owner.fetchAroundStore()
            }
            .withUnretained(self)
            .sink { owner, result in
                switch result {
                case .success(let stores):
                    owner.state.stores = stores
                    
                case .failure(let error):
                    owner.output.route.send(.showErrorAlert(error))
                }
            }
            .store(in: &cancellables)
        
        input.onToggleCertifiedStore
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, _ in
                owner.state.hasMore = true
                owner.state.nextCursor = nil
                owner.state.stores = []
                owner.state.isOnleyCertifiedStore.toggle()
            })
            .asyncMap { owner, _ in
                await owner.fetchAroundStore()
            }
            .withUnretained(self)
            .sink { owner, result in
                switch result {
                case .success(let stores):
                    owner.state.stores = stores
                    
                case .failure(let error):
                    owner.output.route.send(.showErrorAlert(error))
                }
            }
            .store(in: &cancellables)
        
        input.onToggleSort
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, _ in
                owner.state.hasMore = true
                owner.state.nextCursor = nil
                owner.state.stores = []
                owner.state.sortType = owner.state.sortType.toggled()
            })
            .asyncMap { owner, _ in
                await owner.fetchAroundStore()
            }
            .withUnretained(self)
            .sink { owner, result in
                switch result {
                case .success(let stores):
                    owner.state.stores = stores
                    
                case .failure(let error):
                    owner.output.route.send(.showErrorAlert(error))
                }
            }
            .store(in: &cancellables)
        
        input.onTapOnlyBoss
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, _ in
                owner.state.hasMore = true
                owner.state.nextCursor = nil
                owner.state.stores = []
                owner.state.isOnlyBossStore.toggle()
            })
            .asyncMap { owner, _ in
                await owner.fetchAroundStore()
            }
            .withUnretained(self)
            .sink { owner, result in
                switch result {
                case .success(let stores):
                    owner.state.stores = stores
                    
                case .failure(let error):
                    owner.output.route.send(.showErrorAlert(error))
                }
            }
            .store(in: &cancellables)
        
        input.onTapStore
            .withUnretained(self)
            .compactMap { owner, index in
                owner.state.stores[safe: index]?.storeId
            }
            .map { Route.pushStoreDetail(storeId: $0) }
            .subscribe(output.route)
            .store(in: &cancellables)
    }
    
    private func canLoad(index: Int) -> Bool {
        return index == state.stores.count - 1 && state.nextCursor != nil && state.hasMore
    }
    
    private func fetchAroundStore() async -> Result<[StoreCard], Error> {
        var categoryIds: [String]? = nil
        if let filterCategory = state.categoryFilter {
            categoryIds = [filterCategory.category]
        }
        let targetStores: [StoreType] = state.isOnlyBossStore ? [.bossStore] : [.userStore, .bossStore]
        let input = FetchAroundStoreInput(
            distanceM: state.mapMaxDistance,
            categoryIds: categoryIds,
            targetStores: targetStores.map { $0.rawValue },
            sortType: state.sortType.rawValue,
            filterCertifiedStores: state.isOnleyCertifiedStore,
            size: 10,
            cursor: state.nextCursor,
            mapLatitude: state.mapLocation.coordinate.latitude,
            mapLongitude: state.mapLocation.coordinate.longitude
        )
        
        return await storeService.fetchAroundStores(
            input: input,
            latitude: state.currentLocation.coordinate.latitude,
            longitude: state.currentLocation.coordinate.longitude
        )
        .map{ [weak self] response in
            self?.state.hasMore = response.cursor.hasMore
            self?.state.nextCursor = response.cursor.nextCursor
            return response.contents.map(StoreCard.init(response:))
        }
    }
}
