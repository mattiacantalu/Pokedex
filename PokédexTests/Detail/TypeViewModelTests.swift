import XCTest
@testable import Pokedex

class TypeViewModelTests: XCTestCase {
    func testTypes() {
        let pokeType = PokeType(type: Poke(name: "poke_name_1", url: "poke_url_1"))
        let pokeType2 = PokeType(type: Poke(name: "poke_name_2", url: "poke_url_2"))
        let sut = TypeViewModel(types: [pokeType, pokeType2])
        XCTAssertEqual(sut.name.count, 2)
        XCTAssertEqual(sut.name, ["poke_name_1", "poke_name_2"])
    }

    func testEmptyTypesShouldReturnNoNames() {
        let sut = TypeViewModel(types: [])
        XCTAssertEqual(sut.name.count, 0)
    }
}
