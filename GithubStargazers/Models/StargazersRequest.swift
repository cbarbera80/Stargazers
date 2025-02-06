import Foundation

struct StargazersRequest: Encodable {
    let user: String
    let repository: String
    let page: Int
    
    init(user: String, repository: String, page: Int = 0) {
        self.user = user
        self.repository = repository
        self.page = page
    }
}
