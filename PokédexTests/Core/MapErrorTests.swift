import XCTest
@testable import Pokedex

class MapErrorTests: XCTestCase {
    func testMapError() {
        guard let data = JSONMock.loadJson(fromResource: "valid_error") else {
            XCTFail("JSON data error!")
            return
        }

        let url = URL(string: "https://pokeapi.co/api/v2/poke")!
        let response = HTTPURLResponse(url: url,
                                       statusCode: 401,
                                       httpVersion: "1.0",
                                       headerFields: [:])
        
        let session = MockedSession.simulate(failure: response, data: data) { _ in }

        let service = MURLService(session: session,
                                   dispatcher: SyncDispatcher())
        let config =  MURLConfiguration(service: service,
                                        baseUrl: "https://pokeapi.co/api/v2")
        
        do {
            try MServicePerformer(configuration: config).pokedex() { result in
                    switch result {
                    case .success:
                        XCTFail("Should be fail! Got success.")
                    case .failure(let error):
                        XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. ( error 401.)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }
}
