import UIKit

import Common
import DesignSystem
import Model

final class PollItemCell: BaseCollectionViewCell {

    enum Layout {
        static let size = CGSize(width: 280, height: 242)
    }

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = Colors.systemWhite.color
    }

    private let titleLabel = UILabel().then {
        $0.font = Fonts.semiBold.font(size: 20)
        $0.textColor = Colors.gray90.color
    }

    private let userInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }

    private let userNameLabel = UILabel().then {
        $0.font = Fonts.medium.font(size: 12)
        $0.textColor = Colors.gray80.color
    }

    private let selectionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }

    private let firstSelectionView = CommunityPollSelectionView()

    private let secondSelectionView = CommunityPollSelectionView()

    private let commentButton = UIButton().then {
        $0.titleLabel?.font = Fonts.medium.font(size: 12)
        $0.setTitleColor(Colors.gray50.color, for: .normal)
        $0.setImage(Icons.communityLine.image
            .resizeImage(scaledTo: 16)
            .withTintColor(Colors.gray50.color), for: .normal)
        $0.contentEdgeInsets.right = 2
        $0.imageEdgeInsets.left = -2
        $0.titleEdgeInsets.right = -2
    }

    private let countButton = UIButton().then {
        $0.titleLabel?.font = Fonts.medium.font(size: 12)
        $0.setTitleColor(Colors.gray50.color, for: .normal)
        $0.setImage(Icons.fireLine.image
            .resizeImage(scaledTo: 16)
            .withTintColor(Colors.gray50.color), for: .normal)
        $0.contentEdgeInsets.right = 2
        $0.imageEdgeInsets.left = -2
        $0.titleEdgeInsets.right = -2
    }

    private let deadlineLabel = UILabel().then {
        $0.font = Fonts.medium.font(size: 12)
        $0.textColor = Colors.gray50.color
    }

    override func setup() {
        super.setup()

        contentView.addSubViews([
            containerView
        ])

        containerView.addSubViews([
            titleLabel,
            userInfoStackView,
            selectionStackView,
            commentButton,
            countButton,
            deadlineLabel
        ])

        userInfoStackView.addArrangedSubview(userNameLabel)

        selectionStackView.addArrangedSubview(firstSelectionView)
        selectionStackView.addArrangedSubview(secondSelectionView)
    }

    override func bindConstraints() {
        super.bindConstraints()

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }

        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(titleLabel)
        }

        selectionStackView.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(12)
        }

        commentButton.snp.makeConstraints {
            $0.top.equalTo(selectionStackView.snp.bottom).offset(16)
            $0.leading.bottom.equalToSuperview().inset(16)
        }

        countButton.snp.makeConstraints {
            $0.top.bottom.equalTo(commentButton)
            $0.leading.equalTo(commentButton.snp.trailing).offset(12)
        }

        deadlineLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(commentButton)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    func bind(item: PollWithMetaApiResponse) {
        titleLabel.text = item.poll.content.title
        userNameLabel.text = item.pollWriter.name
        commentButton.setTitle("\(item.meta.totalCommentsCount)", for: .normal)
        countButton.setTitle("\(item.meta.totalParticipantsCount)명 투표", for: .normal)
        deadlineLabel.text = item.poll.period.endDateTime

        let firstOption = item.poll.options[safe: 0]
        let secondOption = item.poll.options[safe: 1]

        if firstOption?.choice.selectedByMe ?? false || secondOption?.choice.selectedByMe ?? false { // 선택
            if firstOption?.choice.count ?? 0 > secondOption?.choice.count ?? 0 {
                firstSelectionView.win()
                secondSelectionView.lose()
            } else {
                firstSelectionView.lose()
                secondSelectionView.win()
            }
            firstSelectionView.update(isSelected: firstOption?.choice.selectedByMe ?? false)
            secondSelectionView.update(isSelected: secondOption?.choice.selectedByMe ?? false)
        } else {
            firstSelectionView.nothing()
            secondSelectionView.nothing()
        }

        firstSelectionView.titleLabel.text = firstOption?.name
        firstSelectionView.percentLabel.text = "\(firstOption?.choice.ratio ?? 0)%"
        firstSelectionView.countLabel.text = "\(firstOption?.choice.count ?? 0)명"

        secondSelectionView.titleLabel.text = secondOption?.name
        secondSelectionView.percentLabel.text = "\(secondOption?.choice.count ?? 0)명"
    }
}

// MARK: - CommunityPollSelectionView

final class CommunityPollSelectionView: BaseView {

    enum Layout {
        static let height: CGFloat = 44
    }

    let containerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = Colors.gray30.color.cgColor
        $0.layer.borderWidth = 1
    }

    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }

    let checkImageView = UIImageView().then {
        $0.image = Icons.check.image
            .resizeImage(scaledTo: 16)
            .withTintColor(Colors.mainRed.color)
        $0.isHidden = true
    }

    let titleLabel = UILabel().then {
        $0.font = Fonts.medium.font(size: 16)
        $0.textColor = Colors.gray100.color
        $0.textAlignment = .center
    }

    let emojiLabel = UILabel().then {
        $0.font = Fonts.bold.font(size: 16)
        $0.textColor = Colors.gray100.color
    }

    let percentLabel = UILabel().then {
        $0.font = Fonts.bold.font(size: 16)
        $0.textColor = Colors.gray60.color
    }

    let countLabel = UILabel().then {
        $0.font = Fonts.medium.font(size: 10)
        $0.textColor = Colors.gray40.color
    }

    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
    }

    override func setup() {
        super.setup()

        addSubViews([
            containerView,
        ])

        containerView.addSubViews([
            titleStackView,
            stackView
        ])

        titleStackView.addArrangedSubview(checkImageView)
        titleStackView.addArrangedSubview(titleLabel)

        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(percentLabel)
        stackView.addArrangedSubview(countLabel)
    }

    override func bindConstraints() {
        super.bindConstraints()

        snp.makeConstraints {
            $0.height.equalTo(Layout.height)
        }

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }

        checkImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }

    func nothing() {
        containerView.layer.borderColor = Colors.gray30.color.cgColor
        containerView.backgroundColor = Colors.systemWhite.color

        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.medium.font(size: 16)
        titleLabel.textColor = Colors.gray100.color

        stackView.isHidden = true
    }

    func win() {
        containerView.backgroundColor = Colors.gray100.color

        titleLabel.textAlignment = .left
        titleLabel.font = Fonts.bold.font(size: 12)
        titleLabel.textColor = Colors.systemWhite.color

        stackView.isHidden = false

        percentLabel.textColor = Colors.systemWhite.color
        emojiLabel.text = "🤣"

        countLabel.textColor = Colors.gray30.color
    }

    func lose() {
        containerView.backgroundColor = Colors.systemWhite.color

        titleLabel.textAlignment = .left
        titleLabel.font = Fonts.bold.font(size: 12)
        titleLabel.textColor = Colors.gray60.color

        stackView.isHidden = false

        percentLabel.textColor = Colors.gray60.color
        emojiLabel.text = "😞"

        countLabel.textColor = Colors.gray40.color
    }

    func update(isSelected: Bool) {
        checkImageView.isHidden = !isSelected
        containerView.layer.borderColor = isSelected ? Colors.mainRed.color.cgColor : Colors.gray30.color.cgColor
    }
}
