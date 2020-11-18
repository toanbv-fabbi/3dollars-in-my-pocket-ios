import ObjectMapper


struct Store: Mappable {
    var category: StoreCategory?
    var id: Int?
    var images: [Image] = []
    var latitude: Double?
    var longitude: Double?
    var menus: [Menu]! = []
    var rating: Float!
    var reviews: [Review] = []
    var storeName: String?
    var repoter: User?
    var distance: Int!
    
    
    init(category: StoreCategory? = nil, latitude: Double, longitude: Double, storeName: String,
         menus: [Menu]) {
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.storeName = storeName
        self.menus = menus
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        self.category <- map["category"]
        self.id <- map["id"]
        self.images <- map["image"]
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
        self.menus <- map["menu"]
        self.rating <- map["rating"]
        self.reviews <- map["review"]
        self.storeName <- map["storeName"]
        self.repoter <- map["user"]
        self.distance <- map["distance"]
    }
}