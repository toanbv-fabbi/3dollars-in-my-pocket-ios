import Foundation

import Model

struct FetchMyStoreFeedbacksRequest: RequestType {
    let input: CursorRequestInput
    
    var param: Encodable? {
        return input
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var header: HTTPHeaderType {
        return .auth
    }
    
    var path: String {
        return "/api/v1/my/store-feedbacks"
    }
}
