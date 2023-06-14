import UIKit

import DesignSystem

final class WriteDetailView: BaseView {
    
//    let categoryCellWidth = ((UIScreen.main.bounds.width - 48) - (17 * 4)) / 5
    
    let bgTap = UITapGestureRecognizer().then {
        $0.cancelsTouchesInView = false
    }
    
    private let navigationView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.backgroundColor = DesignSystemAsset.Colors.systemWhite.color
    }
    
    let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Icons.arrowLeft.image, for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "write_detail_title".localized
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        $0.textColor = DesignSystemAsset.Colors.gray100.color
    }
    
    let closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Icons.close.image, for: .normal)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
    
//    let scrollView = UIScrollView().then {
//        $0.showsVerticalScrollIndicator = false
//        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 98, right: 0)
//    }
//
//    let containerView = UIView()
//
//    let locationLabel = UILabel().then {
//        $0.text = "write_location".localized
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
//        $0.textColor = .black
//    }
//
//    let modifyLocationButton = UIButton().then {
//        $0.setTitle("write_modify_location".localized, for: .normal)
//        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
//        $0.setTitleColor(UIColor(r: 255, g: 92, b: 67), for: .normal)
//    }
//
//    let locationContainer = UIView().then {
//        $0.backgroundColor = .white
//    }
//
//    let locationFieldContainer = UIView().then {
//        $0.backgroundColor = UIColor(r: 244, g: 244, b: 244)
//        $0.layer.cornerRadius = 8
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor(r: 208, g: 208, b: 208).cgColor
//    }
//
//    let locationValueLabel = UILabel().then {
//        $0.textColor = .black
//        $0.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
//        $0.text = "주소주소"
//    }
//
//    let storeInfoLabel = UILabel().then {
//        $0.text = "write_store_info".localized
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
//        $0.textColor = .black
//    }
//
//    let storeInfoContainer = UIView().then {
//        $0.backgroundColor = .white
//    }
//
//    let storeNameLabel = UILabel().then {
//        $0.text = "write_store_info_name".localized
//        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
//        $0.textColor = .black
//    }
//
//    let storeNameContainer = UIView().then {
//        $0.layer.cornerRadius = 8
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = UIColor(r: 244, g: 244, b: 244).cgColor
//    }
//
//    let storeNameField = UITextField().then {
//        $0.textColor = .black
//        $0.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
//        $0.placeholder = "write_store_info_name_placeholder".localized
//    }
//
//    let storeTypeLabel = UILabel().then {
//        $0.text = "write_store_type".localized
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
//        $0.textColor = .black
//    }
//
//    let storeTypeOptionLabel = UILabel().then {
//        $0.text = "write_store_option".localized
//        $0.textColor = UIColor(r: 183, g: 183, b: 183)
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
//    }
//
//    let storeTypeStackView = WriteDetailTypeStackView()
//
//    let paymentTypeLabel = UILabel().then {
//        $0.text = "write_store_payment_type".localized
//        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
//        $0.textColor = .black
//    }
//
//    let paymentTypeOptionLabel = UILabel().then {
//        $0.text = "write_store_option".localized
//        $0.textColor = UIColor(r: 183, g: 183, b: 183)
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
//    }
//
//    let paymentTypeMultiLabel = UILabel().then {
//        $0.text = "write_store_payment_multi".localized
//        $0.textColor = UIColor(r: 255, g: 161, b: 170)
//        $0.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
//    }
//
//    let paymentStackView = WriteDetailPaymentStackView()
//
//    let daysLabel = UILabel().then {
//        $0.text = "write_store_days".localized
//        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
//        $0.textColor = .black
//    }
//
//    let daysOptionLabel = UILabel().then {
//        $0.text = "write_store_option".localized
//        $0.textColor = UIColor(r: 183, g: 183, b: 183)
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
//    }
//
//    let dayStackView = DayStackInputView()
//
//    let categoryLabel = UILabel().then {
//        $0.text = "write_store_category".localized
//        $0.textColor = .black
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
//    }
//
//    let deleteAllButton = UIButton().then {
//        $0.setTitle("write_store_delete_all_menu".localized, for: .normal)
//        $0.setTitleColor(UIColor(r: 255, g: 92, b: 67), for: .normal)
//        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
//    }
//
//    let categoryContainer = UIView().then {
//        $0.backgroundColor = .white
//    }
//
//    lazy var categoryCollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: UICollectionViewFlowLayout()
//    ).then {
//        let layout = LeftAlignedCollectionViewFlowLayout()
//
//        layout.minimumInteritemSpacing = 16
//        layout.minimumLineSpacing = 20
//        layout.estimatedItemSize = CGSize(
//            width: self.categoryCellWidth,
//            height: self.categoryCellWidth + 23
//        )
//        $0.collectionViewLayout = layout
//        $0.backgroundColor = .clear
//        $0.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
//    }
//
//    let menuLabel = UILabel().then {
//        $0.text = "write_store_menu".localized
//        $0.textColor = .black
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
//        $0.isHidden = true
//    }
//
//    let menuOptionLabel = UILabel().then {
//        $0.text = "write_store_option".localized
//        $0.textColor = UIColor(r: 183, g: 183, b: 183)
//        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
//        $0.isHidden = true
//    }
//
//    let menuTableView = UITableView().then {
//        $0.backgroundColor = .white
//        $0.isScrollEnabled = false
//        $0.rowHeight = UITableView.automaticDimension
//        $0.separatorStyle = .none
//        $0.sectionFooterHeight = 20
//    }
//
//    let registerButtonBg = UIView().then {
//        $0.layer.cornerRadius = 37
//
//        let shadowLayer = CAShapeLayer()
//
//        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 232, height: 64), cornerRadius: 37).cgPath
//        shadowLayer.fillColor = UIColor.init(r: 255, g: 255, b: 255, a: 0.6).cgColor
//        shadowLayer.shadowColor = UIColor.black.cgColor
//        shadowLayer.shadowPath = nil
//        shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
//        shadowLayer.shadowOpacity = 0.3
//        shadowLayer.shadowRadius = 10
//        $0.layer.insertSublayer(shadowLayer, at: 0)
//    }
//
//    let registerButton = UIButton().then {
//        $0.setTitle("write_store_register_button".localized, for: .normal)
//        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
//        $0.isEnabled = false
//        $0.setBackgroundColor(UIColor.init(r: 208, g: 208, b: 208), for: .disabled)
//        $0.setBackgroundColor(UIColor.init(r: 255, g: 92, b: 67), for: .normal)
//        $0.layer.masksToBounds = true
//    }
    
    let writeButton = UIButton().then {
        $0.backgroundColor = DesignSystemAsset.Colors.mainPink.color
        $0.setTitle("write_store_register_button".localized, for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        $0.setTitleColor(DesignSystemAsset.Colors.systemWhite.color, for: .normal)
    }
    
    private let writeButtonBg = UIView().then {
        $0.backgroundColor = DesignSystemAsset.Colors.mainPink.color
    }
    
    
    override func setup() {
        backgroundColor = DesignSystemAsset.Colors.systemWhite.color
        addSubViews([
            navigationView,
            titleLabel,
            backButton,
            closeButton,
            collectionView,
            writeButton,
            writeButtonBg
        ])
    }
    
    override func bindConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(navigationView)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(navigationView)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(navigationView)
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(writeButton.snp.top)
        }
        
        writeButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(64)
        }
        
        writeButtonBg.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
//        self.navigationView.snp.makeConstraints { (make) in
//            make.left.right.top.equalToSuperview()
//            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60)
//        }
//
//        self.backButton.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.centerY.equalTo(self.titleLabel)
//        }
//
//        self.titleLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(self.navigationView).offset(-22)
//        }
//
//        self.scrollView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalTo(self.navigationView.snp.bottom)
//        }
//
//        self.containerView.snp.makeConstraints { (make) in
//            make.edges.equalTo(0)
//            make.width.equalTo(frame.width)
//            make.top.equalToSuperview()
//            make.bottom.equalTo(self.menuTableView)
//        }
//
//        self.locationLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalToSuperview().offset(40)
//        }
//
//        self.modifyLocationButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-24)
//            make.centerY.equalTo(self.locationLabel)
//        }
//
//        self.locationContainer.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(self.locationLabel.snp.bottom).offset(16)
//            make.bottom.equalTo(self.locationFieldContainer).offset(24)
//        }
//
//        self.locationFieldContainer.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.right.equalToSuperview().offset(-24)
//            make.top.equalTo(self.locationContainer).offset(24)
//            make.bottom.equalTo(self.locationValueLabel).offset(13)
//        }
//
//        self.locationValueLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.locationFieldContainer).offset(16)
//            make.right.equalTo(self.locationFieldContainer).offset(-16)
//            make.top.equalTo(self.locationFieldContainer).offset(16)
//        }
//
//        self.storeInfoLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.locationContainer.snp.bottom).offset(33)
//        }
//
//        self.storeInfoContainer.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(self.storeInfoLabel.snp.bottom).offset(16)
//            make.bottom.equalTo(self.dayStackView).offset(24)
//        }
//
//        self.storeNameLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.storeInfoContainer).offset(30)
//        }
//
//        self.storeNameContainer.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.right.equalToSuperview().offset(-24)
//            make.top.equalTo(self.storeNameLabel.snp.bottom).offset(10)
//            make.bottom.equalTo(self.storeNameField).offset(15)
//        }
//
//        self.storeNameField.snp.makeConstraints { make in
//            make.left.equalTo(self.storeNameContainer).offset(16)
//            make.top.equalTo(self.storeNameContainer).offset(16)
//            make.right.equalTo(self.storeNameContainer).offset(-16)
//        }
//
//        self.storeTypeLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.storeNameContainer.snp.bottom).offset(40)
//        }
//
//        self.storeTypeOptionLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.storeTypeLabel.snp.right).offset(6)
//            make.centerY.equalTo(self.storeTypeLabel)
//        }
//
//        self.storeTypeStackView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.storeTypeLabel.snp.bottom).offset(17)
//        }
//
//        self.paymentTypeLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.storeTypeStackView.snp.bottom).offset(40)
//        }
//
//        self.paymentTypeOptionLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.paymentTypeLabel.snp.right).offset(6)
//            make.centerY.equalTo(self.paymentTypeLabel)
//        }
//
//        self.paymentTypeMultiLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.paymentTypeOptionLabel.snp.right).offset(7)
//            make.centerY.equalTo(self.paymentTypeLabel)
//        }
//
//        self.paymentStackView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.paymentTypeLabel.snp.bottom).offset(16)
//        }
//
//        self.registerButtonBg.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.width.equalTo(232)
//            make.height.equalTo(64)
//            make.bottom.equalToSuperview().offset(-32)
//        }
//
//        self.registerButton.snp.makeConstraints { (make) in
//            make.left.equalTo(registerButtonBg.snp.left).offset(8)
//            make.right.equalTo(registerButtonBg.snp.right).offset(-8)
//            make.top.equalTo(registerButtonBg.snp.top).offset(8)
//            make.bottom.equalTo(registerButtonBg.snp.bottom).offset(-8)
//        }
//
//        self.daysLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.paymentStackView.snp.bottom).offset(40)
//        }
//
//        self.daysOptionLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.daysLabel.snp.right).offset(6)
//            make.centerY.equalTo(self.daysLabel)
//        }
//
//        self.dayStackView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.right.equalToSuperview().offset(-24)
//            make.top.equalTo(self.daysLabel.snp.bottom).offset(13)
//        }
//
//        self.categoryLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.storeInfoContainer.snp.bottom).offset(40)
//        }
//
//        self.deleteAllButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-24)
//            make.centerY.equalTo(self.categoryLabel)
//        }
//
//        self.categoryContainer.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(self.categoryLabel.snp.bottom).offset(16)
//            make.bottom.equalTo(self.categoryCollectionView).offset(24)
//        }
//
//        self.categoryCollectionView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(self.categoryContainer).offset(24)
//            make.height.equalTo(self.categoryCellWidth + 23)
//        }
//
//        self.menuLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(24)
//            make.top.equalTo(self.categoryContainer.snp.bottom).offset(20)
//        }
//
//        self.menuOptionLabel.snp.makeConstraints { make in
//            make.left.equalTo(self.menuLabel.snp.right).offset(4)
//            make.centerY.equalTo(self.menuLabel)
//        }
//
//        self.menuTableView.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.top.equalTo(self.menuLabel.snp.bottom).offset(12)
//            make.height.equalTo(0)
//        }
    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.refreshMenuTableViewHeight()
//        registerButton.layer.cornerRadius = registerButton.frame.height / 2
//    }
//
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        self.refreshMenuTableViewHeight()
//    }
//
//    func refreshCategoryCollectionViewHeight() {
//        self.categoryCollectionView.snp.updateConstraints { make in
//            make.height.equalTo(self.categoryCollectionView.contentSize.height)
//        }
//    }
//
//    func refreshMenuTableViewHeight() {
//        menuTableView.snp.updateConstraints { make in
//            make.height.equalTo(self.menuTableView.contentSize.height)
//        }
//    }
//
//    func setStoreNameBorderColoe(isEmpty: Bool) {
//        self.storeNameContainer.layer.borderColor = isEmpty ? UIColor(r: 244, g: 244, b: 244).cgColor : UIColor(r: 255, g: 161, b: 170).cgColor
//    }
//
//    func setMenuHeader(menuSections: [MenuSection]) {
//        self.menuLabel.isHidden = menuSections.isEmpty
//        self.menuOptionLabel.isHidden = menuSections.isEmpty
//    }
    
    
    private func generateLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    func setSaveButtonEnable(isEnable: Bool) {
        writeButton.isUserInteractionEnabled = isEnable
        writeButton.backgroundColor = isEnable ? DesignSystemAsset.Colors.mainPink.color : DesignSystemAsset.Colors.gray30.color
        writeButtonBg.backgroundColor = isEnable ? DesignSystemAsset.Colors.mainPink.color : DesignSystemAsset.Colors.gray30.color
    }
}
