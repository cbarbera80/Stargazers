import Foundation
import Combine

enum HomeViewStatus: Equatable {
    case loading
    case noData
    case dataFound
    case idle
    case error
}

class HomeViewModel {
    // MARK: - Business properties
    private let services: Networkable
    private(set) var stargazers: [GithubUser]?
    @Published var user: String = ""
    @Published var repo: String = ""
    @Published var status: HomeViewStatus = .idle
    
    private var isUserValid: AnyPublisher<Bool, Never> {
        $user
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isRepoValid: AnyPublisher<Bool, Never> {
        return $repo
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var confirmButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(isUserValid, isRepoValid)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(services: Networkable = DIContainer.shared.resolve(Networkable.self)!) {
        self.services = services
    }
    
    // MARK: - Internal
    func makeRequest() async {
        guard !user.isEmpty, !repo.isEmpty else { return }
        do {
            status = .loading
            stargazers = try await services.getStargazers(from: StargazersRequest(user: user, repository: repo))
            status = .dataFound
        } catch {
            status = .error
        }
    }
}
