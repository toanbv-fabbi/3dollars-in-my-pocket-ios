import Foundation

import Model

struct HomeListSection: Hashable {
    var items: [HomeListSectionItem]
}
        
enum HomeListSectionItem: Hashable {
    case storeCard(StoreCard)
}
