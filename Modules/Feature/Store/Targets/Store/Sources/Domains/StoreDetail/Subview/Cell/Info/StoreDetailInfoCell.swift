import UIKit

import Common
import DesignSystem
import Model

final class StoreDetailInfoCell: BaseCollectionViewCell {
    enum Layout {
        static let height: CGFloat = 121
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray0.color
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray100.color
        label.font = Fonts.bold.font(size: 12)
        label.text = Strings.StoreDetail.Info.storeType
        
        return label
    }()
    
    private let typeValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray70.color
        label.font = Fonts.medium.font(size: 12)
        
        return label
    }()
    
    private let appearanceDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray100.color
        label.font = Fonts.bold.font(size: 12)
        label.text = Strings.StoreDetail.Info.appearanceDay
        
        return label
    }()
    
    private let appearanceDayStackView = StoreDetailInfoAppearanceDayStackView()
    
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray100.color
        label.font = Fonts.bold.font(size: 12)
        label.text = Strings.StoreDetail.Info.paymentMethod
        
        return label
    }()
    
    private let paymentMethodStackView = StoreDetailInfoPaymentStackView()
    
    override func setup() {
        contentView.addSubViews([
            containerView,
            typeLabel,
            typeValueLabel,
            appearanceDayLabel,
            appearanceDayStackView,
            paymentMethodLabel,
            paymentMethodStackView
        ])
    }
    
    override func bindConstraints() {
        containerView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(109)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(17)
            $0.left.equalTo(containerView).offset(16)
            $0.height.equalTo(18)
        }
        
        typeValueLabel.snp.makeConstraints {
            $0.right.equalTo(containerView).offset(-16)
            $0.centerY.equalTo(typeLabel)
        }
        
        appearanceDayLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(8)
            $0.left.equalTo(typeLabel)
            $0.height.equalTo(24)
        }
        
        appearanceDayStackView.snp.makeConstraints {
            $0.centerY.equalTo(appearanceDayLabel)
            $0.right.equalTo(containerView).offset(-16)
        }
        
        paymentMethodLabel.snp.makeConstraints {
            $0.left.equalTo(appearanceDayLabel)
            $0.top.equalTo(appearanceDayLabel.snp.bottom).offset(8)
            $0.height.equalTo(18)
        }
        
        paymentMethodStackView.snp.makeConstraints {
            $0.centerY.equalTo(paymentMethodLabel)
            $0.right.equalTo(containerView).offset(-16)
        }
    }
    
    func bind(_ info: StoreDetailInfo) {
        setSalesType(info.salesType)
        appearanceDayStackView.bind(info.appearanceDays)
        paymentMethodStackView.bind(info.paymentMethods)
    }
    
    private func setSalesType(_ type: SalesType?) {
        let salesType: String
        switch type {
        case .road:
            salesType = Strings.StoreDetail.Info.SalesType.road
            
        case .store:
            salesType = Strings.StoreDetail.Info.SalesType.store
            
        case .convenienceStore:
            salesType = Strings.StoreDetail.Info.SalesType.convenienceStore
            
        default:
            salesType = "-"
        }
        
        typeValueLabel.text = salesType
    }
}
