import XCTest
@testable import Pokedex

class AbilityViewModelTests: XCTestCase {
    func testAbilites() {
        let pokeAbility = PokeAbility(ability: Poke(name: "poke_name_1", url: "poke_url_1"))
        let pokeAbility2 = PokeAbility(ability: Poke(name: "poke_name_2", url: "poke_url_2"))
        let sut = AbilityViewModel(abilities: [pokeAbility, pokeAbility2])
        XCTAssertEqual(sut.names.count, 2)
        XCTAssertEqual(sut.names, ["poke_name_1", "poke_name_2"])
    }

    func testEmptyAbilitiesShouldReturnNoNames() {
        let sut = AbilityViewModel(abilities: [])
        XCTAssertEqual(sut.names.count, 0)
    }
}
