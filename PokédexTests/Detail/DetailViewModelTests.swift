import XCTest
@testable import Pokedex

class DetailViewModelTests: XCTestCase {
    private var sut: DetailViewModel?
    private var imageDownloader: MockedMImageDownloader?
    private var service: MockedMServicePerformer?

    override func setUpWithError() throws {
        imageDownloader = MockedMImageDownloader()
        service = MockedMServicePerformer()
        sut = DetailViewModel(service: try XCTUnwrap(service),
                            imageDownloader: try XCTUnwrap(imageDownloader),
                            poke: Poke(name: "poke_name", url: "poke_url"))
    }
}

extension DetailViewModelTests {
    func testFetch_withSucceededService_shouldSucceed() {
        service?.pokemonHandler = { url, completion in
            XCTAssertEqual(url, "poke_url")
            completion(.success(Pokemon(name: "pokemon_name")))
        }

        sut?.fetch(success: {
            XCTAssertEqual($0.name, "pokemon_name")
            XCTAssertEqual(self.sut?.name, "pokemon_name")
            XCTAssertEqual(self.sut?.weight, "23")
            XCTAssertEqual(self.sut?.height, "77")

            XCTAssertEqual(self.sut?.abiltyViewModel.names.count, 1)
            XCTAssertEqual(self.sut?.abiltyViewModel.names.first, "ability_name")
            
            XCTAssertEqual(self.sut?.moveViewModel.name.count, 1)
            XCTAssertEqual(self.sut?.moveViewModel.name.first, "move_name")
            
            XCTAssertEqual(self.sut?.typeViewModel.name.count, 1)
            XCTAssertEqual(self.sut?.typeViewModel.name.first, "type_name")
            
            XCTAssertEqual(self.sut?.statViewModel.stat.count, 1)
            XCTAssertEqual(self.sut?.statViewModel.stat.first?.name, "stat_name")
            XCTAssertEqual(self.sut?.statViewModel.stat.first?.value, 2)

            XCTAssertEqual(self.sut?.spritesViewModel.count, 2)
        }, failure: { XCTFail("Expected success. Got \($0)") })
        
        XCTAssertEqual(service?.counterPokemon, 1)
    }

    func testFetch_withFailureService_shouldFail() {
        service?.pokemonHandler = { url, completion in
            XCTAssertEqual(url, "poke_url")
            completion(.failure(MockedError.fake))
        }

        sut?.fetch(success: { _ in XCTFail("Expected failure. Got success!") },
                   failure: { XCTAssertEqual($0 as? MockedError, MockedError.fake) })

        XCTAssertEqual(service?.counterPokemon, 1)
    }
}

private extension Pokemon {
    init(name: String) {
        self.init(name: name,
                  experience: 2,
                  weight: 23,
                  height: 77,
                  abilities: [PokeAbility(ability: Poke(name: "ability_name",
                                                        url: "ability_url"))],
                  moves: [PokeMove(move: Poke(name: "move_name",
                                              url: "monve_url"))],
                  types: [PokeType(type: Poke(name: "type_name",
                                              url: "type_url"))],
                  stats: [PokeStat(stat: Poke(name: "stat_name",
                                              url: "stat_url"),
                                   value: 2)],
                  images: PokeImages(back: "back_img",
                                     front: "front_img"))
    }
}
