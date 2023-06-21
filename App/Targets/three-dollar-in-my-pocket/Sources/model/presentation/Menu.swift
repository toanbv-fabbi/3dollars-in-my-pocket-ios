struct Menu: Hashable {
    let category: StreetFoodStoreCategory
    let menuId: Int
    var name: String
    var price: String
    
    init(
        category: StreetFoodStoreCategory,
        name: String = "",
        price: String = ""
    ) {
        self.category = category
        self.menuId = 0
        self.name = name
        self.price = price
    }
    
    init(response: MenuResponse) {
        self.category = response.category
        self.menuId = response.menuId
        self.name = response.name
        self.price = response.price
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Menu {
    var isValid: Bool {
        return name.isNotEmpty
    }
}
