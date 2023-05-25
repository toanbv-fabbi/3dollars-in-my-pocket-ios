import Foundation
import CoreLocation

struct IsStoreExistNearbyRequest: RequestType {
    let distance: Double
    let mapLocation: CLLocation
    
    var param: [String : Any]? {
        return [
            "distance": distance,
            "mapLatitude": mapLocation.coordinate.latitude,
            "mapLongitude": mapLocation.coordinate.longitude
        ]
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var path: String {
        return "/api/v1/stores/near/exists"
    }
}
