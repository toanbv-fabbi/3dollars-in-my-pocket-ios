struct Menu: Codable {
  let id: Int
  let category: StoreCategory?
  var name: String
  var price: String?
  
  init(name: String, price: String? = nil) {
    self.id = -1
    self.category = nil
    self.name = name
    self.price = price
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case category = "category"
    case name = "name"
    case price = "price"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
    self.category = try values.decodeIfPresent(StoreCategory.self, forKey: .category)
    self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    self.price = try values.decodeIfPresent(String.self, forKey: .price)
  }
  
  mutating func setPrice(price: String) {
    self.price = price
  }
  
  func toDict() -> [String: Any] {
    return ["name": name, "price": price]
  }
}
