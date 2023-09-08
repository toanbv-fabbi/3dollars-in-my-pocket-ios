import UIKit

import Common
import DesignSystem

final class ReportPollReasonCell: BaseCollectionViewCell {

    enum Layout {
        static let height: CGFloat = 44
    }

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderColor = Colors.gray40.color.cgColor
        $0.layer.borderWidth = 1
    }

    private let titleLabel = UILabel().then {
        $0.font = Fonts.Pretendard.regular.font(size: 14)
        $0.textColor = Colors.gray60.color
    }

    override func setup() {
        super.setup()

        contentView.addSubViews([
            containerView
        ])

        containerView.addSubViews([
            titleLabel,
        ])
    }

    override func bindConstraints() {
        super.bindConstraints()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }

    func bind(title: String) {
        titleLabel.text = title
    }
}
