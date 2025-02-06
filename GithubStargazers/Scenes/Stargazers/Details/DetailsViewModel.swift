import Foundation
import Combine

enum DetailsViewStatus {
    case idle
    case loading
}

class DetailsViewModel {
    // MARK: - Business properties
    private let services: Networkable
    private let user: String
    private let repo: String
    private(set) var currentPage: Int
    
    @Published var stargazers: [UserViewData] = []
    @Published var status = DetailsViewStatus.idle
    
    var titleText: String {
        return "\(user) - \(repo)"
    }
    
    init(users: [GithubUser], user: String, repo: String, services: Networkable = DIContainer.shared.resolve(Networkable.self)!) {
        self.stargazers = users.map { UserViewData(user: $0) }
        self.user = user
        self.repo = repo
        self.services = services
        self.currentPage = 2
    }
    
    @MainActor
    func makeRequest() async throws {
        
        defer {
            status = .idle
        }
        
        status = .loading
        let users = try await services.getStargazers(from: .init(user: user, repository: repo, page: currentPage))
        stargazers += users.map { UserViewData(user: $0) }
        currentPage += 1
    }
}
