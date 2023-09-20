import UIKit

import Common
import DesignSystem
import Then
import Model

final class CommunityPopularStoreItemCell: BaseCollectionViewCell {

    enum Layout {
        static let size = CGSize(width: UIScreen.main.bounds.width - 40, height: 72)
    }

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = Colors.gray10.color
    }

    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private let titleLabel = UILabel().then {
        $0.font = Fonts.bold.font(size: 16)
        $0.textColor = Colors.gray100.color
    }

    private let tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }

    private let tagLabel = UILabel().then {
        $0.font = Fonts.medium.font(size: 12)
        $0.textColor = Colors.gray40.color
    }

    private let imageView = UIImageView().then {
        $0.backgroundColor = .clear
    }

    override func setup() {
        super.setup()

        contentView.addSubViews([
            containerView
        ])

        containerView.addSubViews([
            titleStackView,
            tagStackView,
            imageView
        ])

        titleStackView.addArrangedSubview(tagStackView)
        titleStackView.addArrangedSubview(titleLabel)

        tagStackView.addArrangedSubview(tagLabel)
    }

    override func bindConstraints() {
        super.bindConstraints()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }

        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }

    func bind(item: PlatformStore) {
        imageView.setImage(urlString: item.categories.first?.imageUrl)
        titleLabel.text = item.name
        tagLabel.text = item.categoriesString
    }
}
