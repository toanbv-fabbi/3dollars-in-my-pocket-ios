import UIKit

class CategoryListHeaderView: BaseView {
    
    let nearImage = UIImageView().then {
        $0.image = UIImage.init(named: "ic_near")
    }
    
    let titleLable = UILabel().then {
        $0.text = "50m 이내"
        $0.textColor = UIColor.init(r: 243, g: 162, b: 169)
        $0.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 12)
    }
    
    override func setup() {
        backgroundColor = .white
        addSubViews(nearImage, titleLable)
    }
    
    override func bindConstraints() {
        nearImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(nearImage.snp.right).offset(6)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRadius()
    }
    
    
    private func setupRadius() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
