import UIKit

public protocol MembershipInterface {
    func createSigninAnonymousViewController() -> UIViewController
    
    func createPolicyViewController() -> UIViewController
    
    func createSigninBottomSheetViewController() -> UIViewController
    
    func createAccountInfoViewController() -> UIViewController
}
