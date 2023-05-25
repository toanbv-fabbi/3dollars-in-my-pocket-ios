struct Location {
    let latitude: Double
    let longitude: Double
    
    init?(response: LocationResponse?) {
        if let response = response {
            self.latitude = response.latitude
            self.longitude = response.longitude
        } else {
            return nil
        }
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
