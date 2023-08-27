import Foundation
import Combine

import DependencyInjection

final public class NetworkManager {
    public static let shared = NetworkManager()
    
    private let requestProvider: RequestProvider
    private let responseProvider: ResponseProvider

    public init() {
        guard let config = DIContainer.shared.container.resolve(NetworkConfigurable.self) else {
            fatalError("⚠️ NetworkConfigurable가 등록되지 않았습니다.")
        }
        
        self.requestProvider = RequestProvider(config: config)
        self.responseProvider = ResponseProvider()
    }

    public func request<T: Decodable>(requestType: RequestType) async -> Result<T, Error> {
        do {
            let response = try await requestProvider.request(requestType: requestType)
            let data: T = try responseProvider.processResponse(data: response.0, response: response.1)
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

extension Result {
    func publish() -> AnyPublisher<Success, Failure> {
        return Result.Publisher(self).eraseToAnyPublisher()
    }
}
