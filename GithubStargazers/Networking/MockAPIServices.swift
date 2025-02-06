import Foundation
import CBNetworking

class MockAPIServices: Networkable {
    enum MockAPIServicesError: Error {
        case mockError
    }
    
    let shouldFail: Bool
    let decoder: JSONDecoder
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getStargazers(from request: StargazersRequest) async throws -> [GithubUser] {
        guard !shouldFail else { throw MockAPIServicesError.mockError }
        
        let data = try JSONMapper<[GithubUser]>().decode(from: "stargazers")
        return data
    }
}
