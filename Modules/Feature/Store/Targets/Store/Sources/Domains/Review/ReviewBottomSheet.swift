import UIKit

import Common
import DesignSystem

final class ReviewBottomSheet: BaseView {
    enum Constant {
        static let maxLengthOfReview = 100
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray100.color
        label.font = Fonts.semiBold.font(size: 20)
        label.text = Strings.ReviewBottomSheet.title
        
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.deleteX.image.withTintColor(Colors.gray40.color), for: .normal)
        
        return button
    }()
    
    let ratingInputView = RatingInputView()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = Strings.ReviewBottomSheet.placeholder
        textView.font = Fonts.regular.font(size: 14)
        textView.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        textView.backgroundColor = Colors.gray10.color
        textView.textColor = Colors.gray100.color
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = Colors.mainPink.color.cgColor
        
        return textView
    }()
    
    let writeButton = Button.Normal(size: .h48, text: Strings.ReviewBottomSheet.writeButton)
    
    override func setup() {
        backgroundColor = Colors.systemWhite.color
        addSubViews([
            titleLabel,
            closeButton,
            ratingInputView,
            textView,
            writeButton
        ])
        
        textView.delegate = self
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(30)
        }
        
        ratingInputView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        textView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(ratingInputView.snp.bottom).offset(12)
            $0.height.equalTo(80)
        }
        
        writeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(textView.snp.bottom).offset(28)
        }
    }
    
    func setRating(_ rating: Int?) {
        let rating = rating ?? 0
        ratingInputView.onTapStackView(tappedIndex: rating)
    }
    
    func setContents(_ contents: String?) {
        if let contents {
            textView.text = contents
            textView.textColor = Colors.gray100.color
        } else {
            textView.text = Strings.ReviewBottomSheet.placeholder
            textView.textColor = Colors.gray40.color
        }
    }
}

// MARK: UITextViewDelegate
extension ReviewBottomSheet: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Strings.ReviewBottomSheet.placeholder {
            textView.text = ""
            textView.textColor = Colors.gray100.color
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = Strings.ReviewBottomSheet.placeholder
            textView.textColor = Colors.gray40.color
        }
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        guard let textFieldText = textView.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        if count == 0 {
            textView.layer.borderWidth = 0
        } else {
            textView.layer.borderWidth = 1
        }
        
        return count <= Constant.maxLengthOfReview
    }
}
