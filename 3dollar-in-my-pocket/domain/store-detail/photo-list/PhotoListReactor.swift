import RxSwift
import RxCocoa
import ReactorKit

final class PhotoListReactor: BaseReactor, Reactor {
    enum Action {
        case viewDidLoad
        case tapPhoto(index: Int)
    }
    
    enum Mutation {
        case setPhotos([Image])
        case showLoading(isShow: Bool)
        case showPhotoDetail(storeId: Int, index: Int, photos: [Image])
        case showErrorAlert(Error)
    }
    
    struct State {
        var photos: [Image]
    }
    
    let initialState: State
    let presentPhotoDetailPublisher = PublishRelay<(Int, Int, [Image])>()
    private let storeId: Int
    private let storeService: StoreServiceProtocol
    
    struct Input {
        let tapPhoto = PublishSubject<Int>()
    }
    
    struct Output {
        let photos = PublishRelay<[Image]>()
        let showPhotoDetail = PublishRelay<(Int, Int, [Image])>()
        let showLoading = PublishRelay<Bool>()
    }
    
    init(
        storeId: Int,
        storeService: StoreServiceProtocol,
        state: State = State(photos: [])
    ) {
        self.storeId = storeId
        self.storeService = storeService
        self.initialState = state
        
        super.init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                .just(.showLoading(isShow: true)),
                self.fetchPhotos(),
                .just(.showLoading(isShow: false))
            ])
            
        case .tapPhoto(let index):
            return .just(.showPhotoDetail(
                storeId: self.storeId,
                index: index,
                photos: self.currentState.photos
            ))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setPhotos(let photos):
            newState.photos = photos
            
        case .showPhotoDetail(let storeId, let index, let photos):
            self.presentPhotoDetailPublisher.accept((storeId, index, photos))
            
        case .showLoading(let isShow):
            self.showLoadingPublisher.accept(isShow)
            
        case .showErrorAlert(let error):
            self.showErrorAlertPublisher.accept(error)
        }
        
        return newState
    }
    
    private func fetchPhotos() -> Observable<Mutation> {
        return self.storeService.fetchStorePhotos(storeId: self.storeId)
            .map { .setPhotos($0) }
            .catch { .just(.showErrorAlert($0)) }
    }
}
