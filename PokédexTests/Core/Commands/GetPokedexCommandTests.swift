import XCTest
@testable import Pokedex

extension MURLCommandTests {
    func testGetPokedexRequest() {
        let session = MockedSession(data: Data(), response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://pokeapi.co/api/v2/pokemon?offset=30&limit=25")
            XCTAssertEqual($0.httpMethod, "GET")
        }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokedex(offset: 30, limit: 25) { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetDefaultPokedexRequest() {
        let session = MockedSession(data: Data(), response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20")
            XCTAssertEqual($0.httpMethod, "GET")
        }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokedex() { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetPokedexResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_get_pokedex") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession(data: data, response: nil, error: nil) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokedex() { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.results.count, 20)
                        XCTAssertEqual(response.results.first?.name, "bulbasaur")
                        XCTAssertEqual(response.results.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetPokedexResponse_withBadData_shouldFail() {
        let session = MockedSession.simulate(failure: MServiceError.noData) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokedex() { result in
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
