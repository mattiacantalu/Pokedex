import XCTest
@testable import Pokedex

extension MURLCommandTests {
    func testGetPokemonRequest() {
        let session = MockedSession(data: Data(), response: nil, error: nil) {
            XCTAssertEqual($0.url?.absoluteString, "https://pokeapi.co/api/v2/pokemon/1")
            XCTAssertEqual($0.httpMethod, "GET")
        }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokemon(by: "https://pokeapi.co/api/v2/pokemon/1") { _ in }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetPokemonResponseShouldSuccess() {
        guard let data = JSONMock.loadJson(fromResource: "valid_get_pokemon") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession(data: data, response: nil, error: nil) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokemon(by: "https://pokeapi.co/api/v2/pokemon/1") { result in
                    switch result {
                    case .success(let response):
                        XCTAssertEqual(response.name, "bulbasaur")
                        XCTAssertEqual(response.height, 7)
                        XCTAssertEqual(response.weight, 69)
                        XCTAssertEqual(response.experience, 64)

                        XCTAssertEqual(response.abilities.count, 2)
                        XCTAssertEqual(response.abilities.first?.ability.name, "overgrow")
                        XCTAssertEqual(response.abilities.first?.ability.url, "https://pokeapi.co/api/v2/ability/65/")

                        XCTAssertEqual(response.moves.count, 78)
                        XCTAssertEqual(response.moves.first?.move.name, "razor-wind")
                        XCTAssertEqual(response.moves.first?.move.url, "https://pokeapi.co/api/v2/move/13/")

                        XCTAssertEqual(response.images.front, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
                        XCTAssertEqual(response.images.back, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")

                        XCTAssertEqual(response.stats.count, 6)
                        XCTAssertEqual(response.stats.first?.stat.name, "hp")
                        XCTAssertEqual(response.stats.first?.stat.url, "https://pokeapi.co/api/v2/stat/1/")
                        XCTAssertEqual(response.stats.first?.value, 45)

                        XCTAssertEqual(response.types.count, 2)
                        XCTAssertEqual(response.types.first?.type.name, "grass")
                        XCTAssertEqual(response.types.first?.type.url, "https://pokeapi.co/api/v2/type/12/")
                    case .failure(let error):
                        XCTFail("Should be success! Got: \(error)")
                    }
                }
        } catch { XCTFail("Unexpected error \(error)!") }
    }

    func testGetPokemonResponse_withBadData_shouldFail() {
        let session = MockedSession.simulate(failure: MServiceError.noData) { _ in }

        do {
            try MServicePerformer(configuration: configure(session))
                .pokedex(next: "https://pokeapi.co/api/v2/pokemon/1") { result in
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
