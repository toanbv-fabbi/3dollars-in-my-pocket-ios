import Foundation
import CoreLocation

struct UserDefaultsUtil {
  
  static let KEY_TOKEN = "KEY_TOKEN"
  static let KEY_USER_ID = "KEY_USER_ID"
  static let KEY_EVENT = "KEY_EVENT"
  static let KEY_CURRENT_LATITUDE = "KEY_CURRENT_LATITUDE"
  static let KEY_CURRENT_LONGITUDE = "KEY_CURRENT_LONGITUDE"
    static let KEY_FOODTRUCK_TOOLTIP = "KEY_FOODTRUCK_TOOLTIP"
    static let KEY_SHARE_LINK_STORE_TYPE = "KEY_SHARE_LINK_STORE_TYPE"
    static let KEY_SHARE_LINK_STORE_ID = "KEY_SHARE_LINK_STORE_ID"
  
  let instance: UserDefaults
  
  
  init(name: String? = nil) {
    if let name = name {
      UserDefaults().removePersistentDomain(forName: name)
      instance = UserDefaults(suiteName: name)!
    } else {
      instance = UserDefaults.standard
    }
  }
    
    var isFoodTruckTooltipShown: Bool {
        get {
            self.instance.bool(forKey: UserDefaultsUtil.KEY_FOODTRUCK_TOOLTIP)
        }
        set {
            self.instance.set(newValue, forKey: UserDefaultsUtil.KEY_FOODTRUCK_TOOLTIP)
        }
    }
    
    var shareLink: String {
        get {
            let storeType = self.instance.string(
                forKey: UserDefaultsUtil.KEY_SHARE_LINK_STORE_TYPE
            ) ?? ""
            let storeId = self.instance.string(
                forKey: UserDefaultsUtil.KEY_SHARE_LINK_STORE_ID
            ) ?? ""
            
            if storeType.isEmpty {
                return ""
            } else {
                return "\(storeType):\(storeId)"
            }
        }
        
        set {
            if newValue.isEmpty {
                self.instance.set(
                    "",
                    forKey: UserDefaultsUtil.KEY_SHARE_LINK_STORE_TYPE
                )
                self.instance.set(
                    "",
                    forKey: UserDefaultsUtil.KEY_SHARE_LINK_STORE_ID
                )
            } else {
                let splitArray = newValue.split(separator: ":")
                let storeType = splitArray.first ?? "streetFood"
                let storeId = splitArray.last ?? ""
                
                self.instance.set(
                    storeType,
                    forKey: UserDefaultsUtil.KEY_SHARE_LINK_STORE_TYPE
                )
                self.instance.set(
                    storeId,
                    forKey: UserDefaultsUtil.KEY_SHARE_LINK_STORE_ID
                )
            }
        }
    }
  
  func setUserToken(token: String) {
    self.instance.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
  }
  
  func getUserToken() -> String {
    return self.instance.string(forKey: UserDefaultsUtil.KEY_TOKEN) ?? ""
  }
  
  func setUserId(id: Int) {
    self.instance.set(id, forKey: UserDefaultsUtil.KEY_USER_ID)
  }
  
  func getUserId() -> Int {
    return self.instance.integer(forKey: UserDefaultsUtil.KEY_USER_ID)
  }
  
  func setEventDisableToday(id: Int) {
    self.instance.set(DateUtils.todayString() ,forKey: "\(UserDefaultsUtil.KEY_EVENT)_\(id)")
  }
  
  func getEventDisableToday(id: Int) -> String {
    return self.instance.string(forKey: "\(UserDefaultsUtil.KEY_EVENT)_\(id)") ?? ""
  }
  
  func setUserCurrentLocation(location: CLLocation) {
    self.instance.set(
      location.coordinate.latitude,
      forKey: UserDefaultsUtil.KEY_CURRENT_LATITUDE
    )
    self.instance.set(
      location.coordinate.longitude,
      forKey: UserDefaultsUtil.KEY_CURRENT_LONGITUDE
    )
  }
  
  func getUserCurrentLocation() -> CLLocation {
    let latitude = self.instance.double(forKey: UserDefaultsUtil.KEY_CURRENT_LATITUDE)
    let longitude = self.instance.double(forKey: UserDefaultsUtil.KEY_CURRENT_LONGITUDE)
    
    return CLLocation(latitude: latitude, longitude: longitude)
  }
  
  func clear() {
    self.instance.removeObject(forKey: UserDefaultsUtil.KEY_USER_ID)
    self.instance.removeObject(forKey: UserDefaultsUtil.KEY_TOKEN)
  }
  
  static func setUserToken(token: String?) {
    UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
  }
  
  static func getUserToken() -> String? {
    return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_TOKEN)
  }
  
  static func setUserId(id: Int?) {
    UserDefaults.standard.set(id, forKey: UserDefaultsUtil.KEY_USER_ID)
  }
  
  static func getUserId() -> Int? {
    UserDefaults.standard.integer(forKey: UserDefaultsUtil.KEY_USER_ID)
  }
  
  static func setEventDisableToday(id: Int) {
    UserDefaults.standard.set(
        DateUtils.todayString(),
        forKey: "\(UserDefaultsUtil.KEY_EVENT)_\(id)"
    )
  }
  
  static func getEventDisableToday(id: Int) -> String? {
    return UserDefaults.standard.string(forKey: "\(UserDefaultsUtil.KEY_EVENT)_\(id)")
  }
  
  static func clear() {
    setUserId(id: nil)
    setUserToken(token: nil)
  }
}
