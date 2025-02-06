import Foundation
import CBNetworking

enum GithubEndpoint {
    case getStargazers(request: StargazersRequest)
}

extension GithubEndpoint: EndpointType {
    var shouldRetryOnFailure: Bool {
        false
    }
    
    var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .getStargazers(let request):
            return "repos/\(request.user)/\(request.repository)/stargazers"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getStargazers:
            return .get
        }
    }
    
    var httpBody: HTTPBodyType? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getStargazers(let request):
            return [URLQueryItem(name: "page", value: String(describing: request.page))]
        }
    }
    
    var headers: [String : Any]? {
        ["Accept": "application/vnd.github.v3+json"]
    }
}
