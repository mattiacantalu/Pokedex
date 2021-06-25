import XCTest
@testable import Pokedex

class MURLRequestTests: XCTestCase {
    func testCreateRequest() {
        guard let url = URL(string: "https://pokeapi.co/api/v2") else {
            XCTFail("URL error!")
            return
        }

        let request = MURLRequest
            .get(url: url)
            .with(component: "pokemon")
            .appendQuery(name: "offset", value: "20")
            .appendQuery(name: "limit", value: "10")
        XCTAssertEqual(request.url.absoluteString, "https://pokeapi.co/api/v2/pokemon?offset=20&limit=10")
        XCTAssertEqual(request.method.rawValue, "GET")
    }
}
