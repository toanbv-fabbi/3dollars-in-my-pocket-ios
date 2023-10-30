import Foundation

public enum ScreenName: String {
    case empty
    
    // Membership
    case signIn = "sign_in"
    case signUp = "sign_up"
    
    // Home
    case home
    case categoryFilter = "category_filter"
    
    /// Write
    case writeAddress = "write_address"
    case writeAddressPopup = "write_address_popop"
    case writeAddressDetail = "write_address_detail"
    
    case categorySelection = "category_selection"
    
    //    case splashPopup = "splash_popup"
    //    case categoryFilter = "category_filter"
    //    case streetFoodList = "street_food_list"
    //    case foodTruckList = "food_truck_list"
}
