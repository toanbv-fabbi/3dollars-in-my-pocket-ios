import Foundation

public struct StoreDetailReview: Hashable {
    public let user: User
    public let reviewId: Int
    public let contents: String
    public let createdAt: String
    public let rating: Int
    public let reportedByMe: Bool
    
    public init(response: ReviewWithUserApiResponse) {
        self.user = User(response: response.reviewWriter)
        self.reviewId = response.review.reviewId
        self.contents = response.review.contents
        self.createdAt = response.review.createdAt
        self.rating = response.review.rating
        self.reportedByMe = response.reviewReport.reportedByMe
    }
}
