import Foundation

import Model

struct StoreDetailSection: Hashable {
    enum StoreDetailSectionType: Hashable {
        case overview
        case visit
        case info
        case photo(totalCount: Int)
    }
    
    var type: StoreDetailSectionType
    var header: StoreDetailSectionHeader?
    var items: [StoreDetailSectionItem]
    
    
}

extension StoreDetailSection {
    var totalCount: Int? {
        if case .photo(let totalCount) = type {
            return totalCount
        } else {
            return nil
        }
    }
    
    static func overviewSection(_ overview: StoreDetailOverview) -> StoreDetailSection {
        return .init(type: .overview, items: [.overview(overview)])
    }
    
    static func visitSection(_ visit: StoreDetailVisit) -> StoreDetailSection {
        return .init(type: .visit, items: [.visit(visit)])
    }
    
    static func infoSection(
        updatedAt: String,
        info: StoreDetailInfo,
        menuCellViewModel: StoreDetailMenuCellViewModel
    ) -> StoreDetailSection {
        let header = StoreDetailSectionHeader(
            title: Strings.StoreDetail.Info.Header.title,
            description: updatedAt,
            value: nil,
            buttonTitle: Strings.StoreDetail.Info.Header.button
        )
        
        return .init(
            type: .info,
            header: header,
            items: [.info(info), .menu(menuCellViewModel)]
        )
    }
    
    static func photoSection(totalCount: Int, photos: [StoreDetailPhoto]) -> StoreDetailSection {
        let header = StoreDetailSectionHeader(
            title: Strings.StoreDetail.Photo.Header.title,
            description: nil,
            value: nil,
            buttonTitle: Strings.StoreDetail.Photo.Header.button
        )
        
        let slicedPhotos: [StoreDetailPhoto]
        if photos.count > 4 {
            slicedPhotos = Array(photos[..<4])
        } else {
            slicedPhotos = photos
        }
        
        return .init(
            type: .photo(totalCount: totalCount),
            header: header,
            items: slicedPhotos.map { .photo($0) }
        )
    }
}
