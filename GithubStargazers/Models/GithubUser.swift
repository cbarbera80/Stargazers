import Foundation

struct GithubUser: Decodable, Equatable, Hashable {
    let login: String
    let id: Int
    let avatarUrl: String
}
