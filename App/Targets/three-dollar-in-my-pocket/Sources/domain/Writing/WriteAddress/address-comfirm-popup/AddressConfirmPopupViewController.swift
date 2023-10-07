import Foundation

protocol AddressConfirmPopupViewControllerDelegate: AnyObject {
    func onClickOk()
}

final class AddressConfirmPopupViewController: BaseBottomSheetViewController {
    weak var delegate: AddressConfirmPopupViewControllerDelegate?
    private let addressConfirmPopupView = AddressConfirmPopupView()
    private let viewModel: AddressConfirmPopupViewModel
    
    static func instacne(address: String) -> AddressConfirmPopupViewController {
        return AddressConfirmPopupViewController(address: address)
    }
    
    init(address: String) {
        self.viewModel = AddressConfirmPopupViewModel(address: address)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addressConfirmPopupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.input.viewDidLoad.send(())
    }
    
    override func bindEvent() {
        addressConfirmPopupView.backgroundView
            .gesture(.tap())
            .withUnretained(self)
            .sink { owner, _ in
                owner.dismiss()
            }
            .store(in: &cancellables)
        
        addressConfirmPopupView.closeButton
            .controlPublisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                owner.dismiss()
            }
            .store(in: &cancellables)
    }
    
    override func bindViewModelInput() {
        addressConfirmPopupView.okButton
            .controlPublisher(for: .touchUpInside)
            .mapVoid
            .subscribe(viewModel.input.tapOk)
            .store(in: &cancellables)
    }
    
    override func bindViewModelOutput() {
        viewModel.output.address
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink(receiveValue: { owner, address in
                owner.addressConfirmPopupView.bind(address: address)
            })
            .store(in: &cancellables)
        
        viewModel.output.route
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, route in
                switch route {
                case .dismiss:
                    owner.dismiss() {
                        owner.delegate?.onClickOk()
                    }
                }
            }
            .store(in: &cancellables)
    }
}