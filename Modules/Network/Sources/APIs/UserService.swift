import Foundation

public protocol UserServiceProtocol {
    func signin(socialType: String, accessToken: String) async -> Result<SigninResponse, Error>
    
    func signup(name: String, socialType: String, token: String) async -> Result<SignupResponse, Error>
    
    func signinAnonymous() async -> Result<SigninResponse, Error>
    
    func fetchUser() async -> Result<UserWithDeviceApiResponse, Error>
}

public struct UserService: UserServiceProtocol {
    public init() { }
    
    public func signin(socialType: String, accessToken: String) async -> Result<SigninResponse, Error> {
        let input = SigninRequestInput(socialType: socialType, token: accessToken)
        let request = SigninRequest(requestInput: input)
        
        return await NetworkManager.shared.request(requestType: request)
    }
    
    public func signup(name: String, socialType: String, token: String) async -> Result<SignupResponse, Error> {
        let input = SignupInput(name: name, socialType: socialType, token: token)
        let request = SignupRequest(requestInput: input)
        
        return await NetworkManager.shared.request(requestType: request)
    }
    
    public func signinAnonymous() async -> Result<SigninResponse, Error> {
        let request = SigninAnonymousRequest()
        
        return await NetworkManager.shared.request(requestType: request)
    }
    
    public func fetchUser() async -> Result<UserWithDeviceApiResponse, Error> {
        let request = FetchUserRequest()
        
        return await NetworkManager.shared.request(requestType: request)
    }
}
