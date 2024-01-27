import Combine

import Common
import Model
import Networking
import AppInterface

final class BookmarkListViewModel: BaseViewModel {
    struct Input {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let willDisplayCell = PassthroughSubject<Int, Never>()
        let didTapShare = PassthroughSubject<Void, Never>()
        let didTapEditOverview = PassthroughSubject<Void, Never>()
        let isDeleteMode = PassthroughSubject<Bool, Never>()
        let didTapDeleteAll = PassthroughSubject<Void, Never>()
        let didTapDelete = PassthroughSubject<Int, Never>()
        let didTapStore = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        let isDeleteMode = CurrentValueSubject<Bool, Never>(false)
        let sections = CurrentValueSubject<[BookmarkListSection], Never>([])
        let route = PassthroughSubject<Route, Never>()
        let showErrorAlert = PassthroughSubject<Error, Never>()
    }
    
    struct State {
        var folderName = ""
        var introduction: String?
        var cursor: String?
        var hasMore = true
        var totalCount = 0
        var stores: [StoreApiResponse] = []
    }
    
    enum Route {
        case presentShareBottomSheet(String)
        case pushStoreDetail(Int)
        case pushBossStoreDetail(String)
        case pushEditBookmark
    }
    
    let input = Input()
    let output = Output()
    private var state = State()
    private let bookmarkService: BookmarkServiceProtocol
    private let globalEventBus: GlobalEventBusProtocol
    
    init(
        bookmarkService: BookmarkServiceProtocol = BookmarkService(),
        globalEventBus: GlobalEventBusProtocol = Environment.appModuleInterface.globalEventBus
    ) {
        self.bookmarkService = bookmarkService
        self.globalEventBus = globalEventBus
    }
    
    override func bind() {
        input.viewDidLoad
            .withUnretained(self)
            .sink { (owner: BookmarkListViewModel, _) in
                owner.fetchBookmarkStore(cursor: owner.state.cursor)
            }
            .store(in: &cancellables)
        
        input.willDisplayCell
            .withUnretained(self)
            .sink { (owner: BookmarkListViewModel, index: Int) in
                guard owner.canLoadMore(index: index) else { return }
                
                owner.fetchBookmarkStore(cursor: owner.state.cursor)
            }
            .store(in: &cancellables)
        
        input.didTapEditOverview
            .withUnretained(self)
            .sink { (owner: BookmarkListViewModel, _) in
                owner.output.route.send(.pushEditBookmark)
            }
            .store(in: &cancellables)
        
        input.isDeleteMode
            .subscribe(output.isDeleteMode)
            .store(in: &cancellables)
        
        input.didTapDelete
            .withUnretained(self)
            .sink { (owner: BookmarkListViewModel, index: Int) in
                guard let store = owner.state.stores[safe: index] else { return }
                
                owner.removeBookmark(store: store, index: index)
            }
            .store(in: &cancellables)
        
        input.didTapDeleteAll
            .withUnretained(self)
            .sink { (owner: BookmarkListViewModel, _) in
                owner.removeAllBookmark()
            }
            .store(in: &cancellables)
        
        input.didTapStore
            .withUnretained(self)
            .sink { (owner: BookmarkListViewModel, index: Int) in
                guard let store = owner.state.stores[safe: index] else { return }
                
                switch store.storeType {
                case .bossStore:
                    owner.output.route.send(.pushBossStoreDetail(store.storeId))
                case .userStore:
                    let storeId = Int(store.storeId) ?? 0
                    owner.output.route.send(.pushStoreDetail(storeId))
                case .unknown:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func canLoadMore(index: Int) -> Bool {
        return state.hasMore && state.cursor.isNotNil && (index >= state.stores.count - 1)
    }
    
    private func fetchBookmarkStore(cursor: String? = nil) {
        Task { [weak self] in
            guard let self else { return }
            
            let input = FetchBookmarkStoreRequestInput(size: 20, cursor: cursor)
            let result = await bookmarkService.fetchBookmarkStore(input: input)
            
            switch result {
            case .success(let response):
                state.cursor = response.cursor.nextCursor
                state.hasMore = response.cursor.hasMore
                state.folderName = response.name
                state.introduction = response.introduction
                state.stores.append(contentsOf: response.favorites)
                
                let sections = createBookmarkListSection()
                output.sections.send(sections)
                
            case .failure(let error):
                output.showErrorAlert.send(error)
            }
        }
        .store(in: taskBag)
    }
    
    private func createBookmarkListSection() -> [BookmarkListSection] {
        let overviewSection = BookmarkListSection(
            type: .overview,
            items: [.overview(name: state.folderName, introduction: state.introduction)]
        )
        
        let headerViewModel = createBookmarkSectionHeaderViewModel()
        let storeCellViewModelList = state.stores.map { store in
            return createBookmarkStoreCellViewModel(store: store)
        }
        let storeSectionItemList = storeCellViewModelList.map { BookmarkListSectionItem.store($0) }
        let storeSection = BookmarkListSection(
            type: .storeList(headerViewModel),
            items: storeSectionItemList
        )
        
        return [overviewSection] + [storeSection]
    }
    
    private func createBookmarkSectionHeaderViewModel() -> BookmarkSectionHeaderViewModel {
        let config = BookmarkSectionHeaderViewModel.Config(
            totalCount: state.totalCount,
            isDeleteMode: output.isDeleteMode.value
        )
        let viewModel = BookmarkSectionHeaderViewModel(config: config)
        
        viewModel.output.didTapDeleteAll
            .subscribe(input.didTapDeleteAll)
            .store(in: &viewModel.cancellables)
        
        viewModel.output.isDeleteMode
            .subscribe(input.isDeleteMode)
            .store(in: &viewModel.cancellables)
        
        return viewModel
    }
    
    private func createBookmarkStoreCellViewModel(store: StoreApiResponse) -> BookmarkStoreCellViewModel {
        let config = BookmarkStoreCellViewModel.Config(
            store: store,
            isDeleteModel: output.isDeleteMode.value
        )
        let viewModel = BookmarkStoreCellViewModel(config: config)
        
        viewModel.output.didTapDelete
            .subscribe(input.didTapDelete)
            .store(in: &viewModel.cancellables)
        
        output.isDeleteMode
            .subscribe(viewModel.input.didChangeDeleteMode)
            .store(in: &viewModel.cancellables)
        
        return viewModel
    }
    
    private func removeBookmark(store: StoreApiResponse, index: Int) {
        guard let storeId = Int(store.storeId) else { return }
        
        Task { [weak self] in
            guard let self else { return }
            
            let result = await bookmarkService.removeBookmarkStore(storeId: storeId)
            
            switch result {
            case .success(_):
                state.stores.remove(at: index)
                output.sections.send(createBookmarkListSection())
            case .failure(let error):
                output.showErrorAlert.send(error)
            }
        }
        .store(in: taskBag)
    }
    
    private func removeAllBookmark() {
        Task { [weak self] in
            guard let self else { return }
            
            let result = await bookmarkService.removeAllBookmarkStore()
            
            switch result {
            case .success:
                state.stores.removeAll()
                output.sections.send(createBookmarkListSection())
            case .failure(let error):
                output.showErrorAlert.send(error)
            }
        }
        .cancel()
    }
}
