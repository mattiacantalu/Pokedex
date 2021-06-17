import XCTest
@testable import Stargazers

class MURLRequestTests: XCTestCase {
    func testCreateRequest() {
        guard let url = URL(string: "https://api.github.com") else {
            XCTFail("URL error!")
            return
        }

        let request = MURLRequest
            .get(url: url)
            .with(component: "repos")
            .with(component: "user1")
            .appendQuery(name: "page", value: "1")
            .appendQuery(name: "per_page", value: "5")
        XCTAssertEqual(request.url.absoluteString, "https://api.github.com/repos/user1?page=1&per_page=5")
        XCTAssertEqual(request.method.rawValue, "GET")
    }
}
