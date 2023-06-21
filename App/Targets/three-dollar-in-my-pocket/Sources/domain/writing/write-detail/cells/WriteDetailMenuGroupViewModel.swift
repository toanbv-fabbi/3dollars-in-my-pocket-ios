import Foundation
import Combine

final class WriteDetailMenuGroupViewModel: Hashable {
    static func == (lhs: WriteDetailMenuGroupViewModel, rhs: WriteDetailMenuGroupViewModel) -> Bool {
        return lhs.output.menus == rhs.output.menus
    }
    
    struct Input {
        let inputMenuName = PassthroughSubject<(Int, String), Never>()
        let inputMenuPrice = PassthroughSubject<(Int, String), Never>()
    }
    
    struct Output {
        let inputMenuName = PassthroughSubject<(IndexPath, String), Never>()
        let inputMenuPrice = PassthroughSubject<(IndexPath, String), Never>()
        var category: PlatformStoreCategory
        var menus: [NewMenu]
    }
    
    struct State {
        var menuIndex: Int
        var category: PlatformStoreCategory
        var menu: [NewMenu]
    }
    
    let input = Input()
    var output: Output
    private var state: State
    private var cancellables = Set<AnyCancellable>()
    
    init(state: State) {
        self.state = state
        
        output = Output(category: state.category, menus: state.menu)
        bind()
    }
    
    private func bind() {
        input.inputMenuName
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, input in
                let (index, name) = input
                
                owner.state.menu[index].name = name
            })
            .map { owner, input in
                let (index, name) = input
                let indexPath = IndexPath(row: index, section: owner.state.menuIndex)
                
                return (indexPath, name)
            }
            .subscribe(output.inputMenuName)
            .store(in: &cancellables)
        
        input.inputMenuPrice
            .withUnretained(self)
            .handleEvents(receiveOutput: { owner, input in
                let (index, price) = input
                
                owner.state.menu[index].price = price
            })
            .map { owner, input in
                let (index, price) = input
                let indexPath = IndexPath(row: index, section: owner.state.menuIndex)
                
                return (indexPath, price)
            }
            .subscribe(output.inputMenuPrice)
            .store(in: &cancellables)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(output.menus)
    }
}
