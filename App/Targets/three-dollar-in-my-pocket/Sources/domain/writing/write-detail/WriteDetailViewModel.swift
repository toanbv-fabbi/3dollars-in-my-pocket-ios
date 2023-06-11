import Foundation
import Combine

import Networking
import Common

final class WriteDetailViewModel {
    struct Input {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let tapFullMap = PassthroughSubject<Void, Never>()
        let tapEditLocation = PassthroughSubject<Void, Never>()
        let storeName = PassthroughSubject<String, Never>()
        let tapStoreType = PassthroughSubject<StreetFoodStoreType, Never>()
        let tapPaymentMethod = PassthroughSubject<PaymentType, Never>()
        let tapDay = PassthroughSubject<DayOfTheWeek, Never>()
        let tapAddCategory = PassthroughSubject<Void, Never>()
        let tapDeleteCategory = PassthroughSubject<Int, Never>()
        let addCategories = PassthroughSubject<[PlatformStoreCategory], Never>()
        let deleteAllCategories = PassthroughSubject<Void, Never>()
        let inputMenuName = PassthroughSubject<(IndexPath, String), Never>()
        let inputMenuPrice = PassthroughSubject<(IndexPath, String), Never>()
        let tapSave = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let isSaveButtonEnable = PassthroughSubject<Bool, Never>()
        let showLoading = PassthroughSubject<Bool, Never>()
        let route = PassthroughSubject<Route, Never>()
        let error = PassthroughSubject<Error, Never>()
        let sections = PassthroughSubject<[WriteDetailSection], Never>()
    }
    
    private struct State {
        var location: Location
        var addess: String
        var name = ""
        var storeType: StreetFoodStoreType?
        var paymentMethods: [PaymentType] = []
        var appearanceDays: [DayOfTheWeek] = []
        var categories: [PlatformStoreCategory] = []
        var menu: [[Menu]] = []
    }
    
    enum Route {
        case pop
        case presentFullMap
        case presentCategorySelection
        case dismiss
    }
    
    let input = Input()
    let output = Output()
    private var state: State
    private let storeService: Networking.StoreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        location: Location,
        address: String,
        storeService: Networking.StoreServiceProtocol = Networking.StoreService()
    ) {
        self.state = State(location: location, addess: address)
        self.storeService = storeService
        
        bind()
    }
    
    private func bind() {
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.updateSections()
                owner.updateSaveButtonEnable()
            }
            .store(in: &cancellables)
        
        input.tapFullMap
            .map { .presentFullMap }
            .subscribe(output.route)
            .store(in: &cancellables)
        
        input.tapEditLocation
            .map { .pop }
            .subscribe(output.route)
            .store(in: &cancellables)
        
        input.storeName
            .withUnretained(self)
            .sink { owner, name in
                owner.state.name = name
                owner.updateSaveButtonEnable()
            }
            .store(in: &cancellables)
        
        input.tapStoreType
            .withUnretained(self)
            .sink { owner, storeType in
                owner.state.storeType = storeType
            }
            .store(in: &cancellables)
        
        input.tapPaymentMethod
            .withUnretained(self)
            .sink { owner, paymentMethod in
                if let targetIndex = owner.state.paymentMethods.firstIndex(of: paymentMethod) {
                    owner.state.paymentMethods.remove(at: targetIndex)
                } else {
                    owner.state.paymentMethods.append(paymentMethod)
                }
            }
            .store(in: &cancellables)
        
        input.tapDay
            .withUnretained(self)
            .sink { owner, dayOfTheWeek in
                if let targetIndex = owner.state.appearanceDays.firstIndex(of: dayOfTheWeek) {
                    owner.state.appearanceDays.remove(at: targetIndex)
                } else {
                    owner.state.appearanceDays.append(dayOfTheWeek)
                }
            }
            .store(in: &cancellables)
        
        input.tapAddCategory
            .map { .presentCategorySelection }
            .subscribe(output.route)
            .store(in: &cancellables)
        
        input.tapDeleteCategory
            .withUnretained(self)
            .sink { owner, index in
                owner.state.categories.remove(at: index)
                owner.updateSaveButtonEnable()
                owner.updateSections()
            }
            .store(in: &cancellables)
        
        input.addCategories
            .withUnretained(self)
            .sink { owner, addedCategories in
                owner.state.categories.append(contentsOf: addedCategories)
                owner.updateSaveButtonEnable()
                owner.updateSections()
            }
            .store(in: &cancellables)
        
        input.deleteAllCategories
            .withUnretained(self)
            .sink { owner, _ in
                owner.state.categories.removeAll()
                owner.updateSaveButtonEnable()
                owner.updateSections()
            }
            .store(in: &cancellables)
        
        input.inputMenuName
            .withUnretained(self)
            .sink { owner, nameWithIndex in
                let (indexPath, name) = nameWithIndex
                guard owner.isExistMenu(indexPath: indexPath) else { return }
                
                owner.state.menu[indexPath.section][indexPath.row].name = name
            }
            .store(in: &cancellables)
        
        input.inputMenuPrice
            .withUnretained(self)
            .sink { owner, priceWithIndex in
                let (indexPath, price) = priceWithIndex
                guard owner.isExistMenu(indexPath: indexPath) else { return }
                
                owner.state.menu[indexPath.section][indexPath.row].price = price
            }
            .store(in: &cancellables)
        
        input.tapSave
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, _ in
                owner.output.showLoading.send(true)
            })
            .map { owner, _ in
                owner.createStoreCreateRequestInput()
            }
            .withUnretained(self)
            .asyncMap { owner, input in
                await owner.storeService.createStore(input: input)
            }
            .withUnretained(self)
            .sink { owner, result in
                owner.output.showLoading.send(false)
                switch result {
                case .success(let response):
                    // TODO: GlobalEvnet로 응답 전달 필요. (홈 화면에 새로운 카드 추가, 가게 상세화면 이동)
                    owner.output.route.send(.dismiss)

                case .failure(let error):
                    owner.output.error.send(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateSaveButtonEnable() {
        let isEnable = state.name.isNotEmpty && state.menu.isNotEmpty
        output.isSaveButtonEnable.send(isEnable)
    }
    
    private func updateSections() {
        var sections: [WriteDetailSection] = [
            WriteDetailSection(type: .map, items: [.map(state.location)]),
            WriteDetailSection(type: .address, items: [.address(state.addess)]),
            WriteDetailSection(type: .name, items: [.name(state.name)]),
            WriteDetailSection(type: .storeType, items: [.storeType]),
            WriteDetailSection(type: .paymentMethod, items: [.paymentMethod]),
            WriteDetailSection(type: .appearanceDay, items: [.appearanceDay]),
            WriteDetailSection(type: .category, items: [.categoryCollection([nil] + state.categories)])
        ]
        
        // TODO: 메뉴 그룹 설정 필요
        output.sections.send(sections)
    }
    
    private func isExistMenu(indexPath: IndexPath) -> Bool {
        guard let categoryMenus = state.menu[safe: indexPath.section],
              let _ = categoryMenus[safe: indexPath.row] else { return false }
        
        return true
    }
    
    private func createStoreCreateRequestInput() -> StoreCreateRequestInput {
        return StoreCreateRequestInput(
            latitude: state.location.latitude,
            longitude: state.location.longitude,
            storeName: state.name,
            storeType: state.storeType?.rawValue,
            appearanceDays: state.appearanceDays.map { $0.rawValue },
            paymentMethods: state.paymentMethods.map { $0.rawValue },
            menus: []
        )
    }
}
