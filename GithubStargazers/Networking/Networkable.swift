import Foundation

protocol Networkable {
    func getStargazers(from request: StargazersRequest) async throws -> [GithubUser]
}
