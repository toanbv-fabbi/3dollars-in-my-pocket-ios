import UIKit

import Common
import DesignSystem

final class SettingAdBanner: BaseView {
    enum Layout {
        static let height: CGFloat = 64
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Colors.mainPink.color
        label.font = Fonts.semiBold.font(size: 14)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Colors.gray40.color
        label.font = Fonts.medium.font(size: 12)
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        let image = Icons.arrowRight.image.withRenderingMode(.alwaysTemplate)
        
        imageView.image = image
        imageView.tintColor = Colors.gray40.color
        return imageView
    }()
    
    private let bannerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let button = UIButton()
    
    init(bannerType: SettingAdBannerType) {
        super.init(frame: .zero)
        
        bind(bannerType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        backgroundColor = .clear
        addSubViews([
            titleLabel,
            descriptionLabel,
            arrowImage,
            bannerImage,
            button
        ])
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(13)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        arrowImage.snp.makeConstraints {
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(2)
            $0.size.equalTo(12)
            $0.centerY.equalTo(descriptionLabel)
        }
        
        bannerImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.equalTo(88)
            $0.height.equalTo(64)
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.height.equalTo(Layout.height).priority(.high)
        }
    }
    
    private func bind(_ type: SettingAdBannerType) {
        titleLabel.text = type.title
        titleLabel.textColor = type.titleColor
        descriptionLabel.text = type.description
        bannerImage.image = type.bannerImage
    }
}
