import UIKit

import Common
import Then
import SnapKit

final class SigninView: BaseView {
    private let logoImage = UIImageView(image: Assets.imageSplash.image)
    
    let kakaoButton = SigninButton(type: .kakao)
    
    let appleButton = SigninButton(type: .apple)
    
    let signinAnonymousButton = UIButton().then {
        $0.setTitle(Strings.signinAnonymous, for: .normal)
        $0.setTitleColor(Colors.systemWhite.color, for: .normal)
        $0.titleLabel?.font = Fonts.regular.font(size: 14)
    }
    
    override func setup() {
        logoImage.contentMode = .scaleAspectFit
        backgroundColor = Colors.mainPink.color
        addSubViews([
            logoImage,
            kakaoButton,
            appleButton,
            signinAnonymousButton
        ])
    }
    
    override func bindConstraints() {
        logoImage.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview().offset(-32)
            $0.bottom.equalTo(kakaoButton.snp.top).offset(-72)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(48)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
        
        appleButton.snp.makeConstraints {
            $0.left.equalTo(kakaoButton)
            $0.right.equalTo(kakaoButton)
            $0.top.equalTo(kakaoButton.snp.bottom).offset(12)
            $0.height.equalTo(48)
        }
        
        signinAnonymousButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(appleButton.snp.bottom).offset(20)
        }
    }
}
