@testable import GithubStargazers
import XCTest

class DetailViewModelTest: XCTestCase {
    private func getSUT(users: [GithubUser] = [], user: String = "user1", repo: String = "repo") -> DetailsViewModel {
        return DetailsViewModel(users: users, user: user, repo: repo, services: MockAPIServices())
    }
    
    func test_initialState() {
        let sut = getSUT()
        XCTAssertEqual(sut.stargazers.count, 0)
        XCTAssertEqual(sut.status, .idle)
        XCTAssertEqual(sut.titleText, "user1 - repo")
    }
    
    func test_makeRequest_fetchesNewUsers()  async throws {
        let sut = getSUT()
        try await sut.makeRequest()
        
        XCTAssertFalse(sut.stargazers.isEmpty)
    }
    
    func test_makeRequest_appendsNewUsers() async throws {
        let sut = getSUT()
          
        let initialCount = sut.stargazers.count
        try await sut.makeRequest()
        
        XCTAssertGreaterThan(sut.stargazers.count, initialCount)
    }
    
    func test_titleText_isFormattedCorrectly() {
        let sut = getSUT(user: "cb", repo: "80")
        XCTAssertEqual(sut.titleText, "cb - 80")
    }
    
    func test_makeRequest_incrementsCurrentPage() async throws {
        let sut = getSUT()
        let initialPage = sut.currentPage
        
        try await sut.makeRequest()
        
        XCTAssertEqual(sut.currentPage, initialPage + 1)
    }
}
