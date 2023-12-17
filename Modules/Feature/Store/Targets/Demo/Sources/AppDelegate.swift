import UIKit

import Common
import Store
import Networking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        initializationNetworkModule()
        initializationUserDefault()
        return true
    }
      
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func initializationNetworkModule() {
        MockAppModuleInterfaceImpl.registerAppModuleInterface()
        MockNetworkConfiguration.registerNetworkConfiguration()
        MockAppInfomationImpl.registerAppInfomation()
    }
    
    private func initializationUserDefault() {
        UserDefaultsUtil().userId = 244
    }
}
