import UIKit

class ShopCell: BaseCollectionViewCell {
    
    static let registerId = "\(ShopCell.self)"
    
    let distanceLabel = UILabel().then {
        $0.text = "100m"
        $0.textColor = UIColor.init(r: 243, g: 162, b: 169)
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 16)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 12.5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.init(r: 243, g: 162, b: 169).cgColor
    }
    
    let imageBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "img_card_bungeoppang_off"), for: .normal)
        $0.setImage(UIImage.init(named: "img_card_bungeoppang_on"), for: .selected)
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }
    
    let rankingView = RankingView()
    
    override func setup() {
        layer.cornerRadius = 16
        backgroundColor = UIColor.init(r: 251, g: 251, b: 251)
        setupShadow()
        addSubViews(distanceLabel, imageBtn, rankingView)
    }
    
    override func bindConstraints() {
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(56)
            make.height.equalTo(25)
        }
        
        imageBtn.snp.makeConstraints { (make) in
            make.top.equalTo(distanceLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        rankingView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-14)
            make.top.equalTo(distanceLabel.snp.bottom).offset(105)
        }
    }

    func setSelected(isSelected: Bool) {
        if isSelected {
            layer.backgroundColor = UIColor.init(r: 28, g: 28, b: 28).cgColor
        } else {
            layer.backgroundColor = UIColor.init(r: 251, g: 251, b: 251).cgColor
        }
        imageBtn.isSelected = isSelected
        rankingView.setSelected(isSelected: isSelected)
    }
    
    func bind(storeCard: StoreCard) {
        switch storeCard.category {
        case .BUNGEOPPANG:
            imageBtn.setImage(UIImage.init(named: "img_card_bungeoppang_off"), for: .normal)
            imageBtn.setImage(UIImage.init(named: "img_card_bungeoppang_on"), for: .selected)
        case .GYERANPPANG:
            imageBtn.setImage(UIImage.init(named: "img_card_gyeranppang_off"), for: .normal)
            imageBtn.setImage(UIImage.init(named: "img_card_gyeranppang_on"), for: .selected)
        case .HOTTEOK:
            imageBtn.setImage(UIImage.init(named: "img_card_hotteok_off"), for: .normal)
            imageBtn.setImage(UIImage.init(named: "img_card_hotteok_on"), for: .selected)
        case .TAKOYAKI:
            imageBtn.setImage(UIImage.init(named: "img_card_takoyaki_off"), for: .normal)
            imageBtn.setImage(UIImage.init(named: "img_card_takoyaki_on"), for: .selected)
        default:
            break
        }
        if storeCard.distance >= 1000 {
            distanceLabel.text = "1km+"
        } else {
            distanceLabel.text = "\(storeCard.distance!)m"
        }
        
        rankingView.setRank(rank: storeCard.rating)
    }
    
    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.2

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}