import Foundation
import CBNetworking

class NetworkingManager: Networkable {
    private let networking: CBNetworking<GithubEndpoint>
    
    let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        networking = CBNetworking<GithubEndpoint>(decoder: decoder, logger: CurlLogger())
    }
    
    func getStargazers(from request: StargazersRequest) async throws -> [GithubUser] {
        try await networking.send(endpoint: .getStargazers(request: request))
    }
}
