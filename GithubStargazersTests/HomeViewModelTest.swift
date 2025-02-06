@testable import GithubStargazers
import XCTest

class HomeViewModelTest: XCTestCase {
    private func getSUT() -> HomeViewModel {
        return HomeViewModel(services: MockAPIServices())
    }
    
    func test_initialState() {
        let sut = getSUT()
        XCTAssertEqual(sut.status, .idle)
        XCTAssertNil(sut.stargazers)
        XCTAssertEqual(sut.user, "")
        XCTAssertEqual(sut.repo, "")
    }
    
    func test_confirmButtonEnabled_publishesCorrectValues() {
        let sut = getSUT()
        var results: [Bool] = []
        let cancellable = sut.confirmButtonEnabled.sink { results.append($0) }
        
        sut.user = "user1"
        sut.repo = ""
        sut.repo = "repo1"
        
        XCTAssertEqual(results, [false, false, false, true])
        cancellable.cancel()
    }
    
    func test_makeRequest_withValidInput_fetchesData() async throws {
        let sut = getSUT()
        sut.user = "user1"
        sut.repo = "repo1"
        
        await sut.makeRequest()
        
        XCTAssertEqual(sut.status, .dataFound)
        XCTAssertNotNil(sut.stargazers)
    }
    
    func test_makeRequest_withInvalidInput_doesNothing() async {
        let sut = getSUT()
        await sut.makeRequest()
        
        XCTAssertEqual(sut.status, .idle)
        XCTAssertNil(sut.stargazers)
    }
    
    func test_makeRequest_withError_setsStatusToError() async throws {
        let sut = HomeViewModel(services: MockAPIServices(shouldFail: true))
        sut.user = "user1"
        sut.repo = "repo1"
        
        await sut.makeRequest()
        
        XCTAssertEqual(sut.status, .error)
    }
}
