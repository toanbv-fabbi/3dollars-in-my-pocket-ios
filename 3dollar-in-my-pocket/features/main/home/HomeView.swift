import UIKit
import GoogleMaps

class HomeView: BaseView {
    
    let bungeoppangTap = UITapGestureRecognizer()
    let takoyakiTap = UITapGestureRecognizer()
    let gyeranppangTap = UITapGestureRecognizer()
    let hotteokTap = UITapGestureRecognizer()
    
    let bgCloud = UIImageView().then {
        $0.image = UIImage.init(named: "bg_cloud_main")
        $0.contentMode = .scaleToFill
    }
    
    let categoryStackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .horizontal
        $0.backgroundColor = .white
        $0.distribution = .equalCentering
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 18)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let mapView = GMSMapView()
    
    let bungeoppangBtn = CategoryButton()
    
    let takoyakiBtn = CategoryButton()
    
    let gyeranppangBtn = CategoryButton()
    
    let hotteokBtn = CategoryButton()
    
    let descLabel1 = UILabel().then {
        $0.text = "가장 가까운 음식점"
        $0.textColor = UIColor.init(r: 238, g: 98, b: 76)
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 12)
    }
    
    let descLabel2 = UILabel().then {
        let text = "지금 당장"
        let attributedStr = NSMutableAttributedString(string: text)

        attributedStr.addAttribute(.kern, value: -1.6, range: NSMakeRange(0, text.count-1))
        $0.textColor = .black
        $0.font = UIFont.init(name: "SpoqaHanSans-Light", size: 32)
        $0.attributedText = attributedStr
    }
    
    let descLabel3 = UILabel().then {
        let text = "3천원이 있으시다면"
        let attributedStr = NSMutableAttributedString(string: text)
        let subFont = UIFont.init(name: "SpoqaHanSans-Bold", size: 32)

        attributedStr.addAttribute(.font, value: subFont!, range: (text as NSString).range(of: "3천원"))
        attributedStr.addAttribute(.kern, value: -1.6, range: NSMakeRange(0, text.count-1))
        $0.textColor = .black
        $0.font = UIFont.init(name: "SpoqaHanSans-Light", size: 32)
        $0.attributedText = attributedStr
    }
    
    let shopCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 196)
    }
    
    
    let mapButton = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_location"), for: .normal)
    }
    
    override func setup() {
        backgroundColor = UIColor.init(r: 245, g: 245, b: 245)
        gyeranppangBtn.addGestureRecognizer(gyeranppangTap)
        hotteokBtn.addGestureRecognizer(hotteokTap)
        bungeoppangBtn.addGestureRecognizer(bungeoppangTap)
        takoyakiBtn.addGestureRecognizer(takoyakiTap)
        
        
        categoryStackView.addArrangedSubview(bungeoppangBtn)
        categoryStackView.addArrangedSubview(takoyakiBtn)
        categoryStackView.addArrangedSubview(gyeranppangBtn)
        categoryStackView.addArrangedSubview(hotteokBtn)
        setupStackViewShadow()
        addSubViews(bgCloud, categoryStackView, mapView, descLabel1, descLabel2, descLabel3, shopCollectionView, mapButton)
    }
    
    override func bindConstraints() {
        bgCloud.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(93)
        }
        
        categoryStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22 * UIScreen.main.bounds.width / 375.0)
            make.right.equalToSuperview().offset(-26 * UIScreen.main.bounds.width / 375.0)
            make.top.equalToSuperview().offset(56)
            make.height.equalTo(92)
        }
        
        bungeoppangBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(categoryStackView.snp.left).offset(21 * UIScreen.main.bounds.width / 375.0)
            make.width.height.equalTo(67 * UIScreen.main.bounds.width / 375.0)
        }
        
        takoyakiBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(bungeoppangBtn.snp.right).offset(8 * UIScreen.main.bounds.width / 375.0)
            make.width.height.equalTo(67 * UIScreen.main.bounds.width / 375.0)
        }
        
        gyeranppangBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(takoyakiBtn.snp.right).offset(8 * UIScreen.main.bounds.width / 375.0)
            make.width.height.equalTo(67 * UIScreen.main.bounds.width / 375.0)
        }
        
        hotteokBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(gyeranppangBtn.snp.right).offset(8 * UIScreen.main.bounds.width / 375.0)
            make.width.height.equalTo(67 * UIScreen.main.bounds.width / 375.0)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(categoryStackView.snp.bottom).offset(264 * UIScreen.main.bounds.width / 375.0)
        }
        
        descLabel1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(categoryStackView.snp.bottom).offset(41)
        }
        
        descLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel1.snp.left)
            make.top.equalTo(descLabel1.snp.bottom).offset(-4)
        }
        
        descLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel1.snp.left)
            make.top.equalTo(descLabel2.snp.bottom).offset(-8)
        }
        
        shopCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(descLabel3.snp.bottom).offset(23)
            make.height.equalTo(200)
        }
        
        mapButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-120)
        }
    }
    
    private func setupStackViewShadow() {
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width-48, height: 92), cornerRadius: 24).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = nil
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 20
        
        categoryStackView.layer.insertSublayer(shadowLayer, at: 0)
    }
}
