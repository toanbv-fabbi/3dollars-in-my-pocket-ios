import DesignSystem
import StoreInterface
import CommunityInterface
import DependencyInjection

typealias Fonts = DesignSystemFontFamily.Pretendard
typealias Colors = DesignSystemAsset.Colors
typealias Strings = ThreeDollarInMyPocketStrings
typealias Assets = ThreeDollarInMyPocketAsset.Assets
typealias Icons = DesignSystemAsset.Icons


final class Environment {
    static var storeInterface : StoreInterface {
        guard let storeInterface = DIContainer.shared.container.resolve(StoreInterface.self) else {
            fatalError("StoreInterface가 정의되지 않았습니다.")
        }
        
        return storeInterface
    }

    static var communityInterface: CommunityInterface {
        guard let communityInterface = DIContainer.shared.container.resolve(CommunityInterface.self) else {
            fatalError("StoreInterface가 정의되지 않았습니다.")
        }

        return communityInterface
    }
}