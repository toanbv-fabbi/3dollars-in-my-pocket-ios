import Foundation

public struct Advertisement {
    let advertisementId: Int
    let title: String?
    let subTitle: String?
    let extraContent: String?
    let imageUrl: String?
    let imageWidth: Int
    let imageHeight: Int
    let linkUrl: String?
    let bgColor: String?
    let fontColor: String?
    
    public init(response: AdvertisementResponse) {
        self.advertisementId = response.advertisementId
        self.title = response.title
        self.subTitle = response.subTitle
        self.extraContent = response.extraContent
        self.imageUrl = response.imageUrl
        self.imageWidth = response.imageWidth
        self.imageHeight = response.imageHeight
        self.linkUrl = response.linkUrl
        self.bgColor = response.bgColor
        self.fontColor = response.fontColor
    }
}

extension Advertisement: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(advertisementId)
    }
}