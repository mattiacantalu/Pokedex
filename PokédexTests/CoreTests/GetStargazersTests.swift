import XCTest
@testable import Stargazers

extension MURLCommandTests {
    func testGetStargazersRequest() {
        guard let data = JSONMock.loadJson(fromResource: "valid_stargazer") else {
            XCTFail("JSON data error!")
            return
        }

        let session = MockedSession(data: data, response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://api.github.com/repos/user1/myrepo/stargazers?per_page=20&page=1")
            XCTAssertEqual($0.httpMethod, "GET")
        }

        do {
            try MServicePerformer(configuration: configure(session))
                .stargazers(for: MUser(name: "user1", repo: "myrepo"), page: 1) { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetStargazersResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_stargazer") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession(data: data, response: nil, error: nil) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .stargazers(for: MUser(name: "", repo: ""), page: 0) { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.count, 8)
                        XCTAssertEqual(response.first?.user, "dcampogiani")
                        XCTAssertEqual(response.first?.avatar, "https://avatars.githubusercontent.com/u/1054526?v=4")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetStargazersResponse_withBadData_shouldFail() {
        let session = MockedSession.simulate(failure: MServiceError.noData) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .stargazers(for: MUser(name: "", repo: ""), page: 0) { result in
                    switch result {
                    case .success:
                        XCTFail("Should be fail! Got success.")
                    case .failure(let error):
                        guard let mError = error as? MServiceError else {
                            XCTFail("Unexpected error type!")
                            return
                        }
                        XCTAssert(mError == MServiceError.noData)
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
}
