import Foundation

import Model

public protocol FeedbackServiceProtocol {
    func sendFeedbacks(targetType: String, targetId: String, feedbackTypes: [FeedbackType]) async -> Result<String?, Error>
}

public struct FeedbackService: FeedbackServiceProtocol {
    public init() { }

    public func sendFeedbacks(targetType: String, targetId: String, feedbackTypes: [FeedbackType]) async -> Result<String?, Error> {
        let request = SendFeedbacksRequest(targetType: targetType, targetId: targetId, feedbackTypes: feedbackTypes)

        return await NetworkManager.shared.request(requestType: request)
    }
}
