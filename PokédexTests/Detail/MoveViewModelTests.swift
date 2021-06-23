import XCTest
@testable import Pokedex

class MoveViewModelTests: XCTestCase {
    func testMoves() {
        let pokeMove = PokeMove(move: Poke(name: "poke_name_1", url: "poke_url_1"))
        let pokeMove2 = PokeMove(move: Poke(name: "poke_name_2", url: "poke_url_2"))
        let sut = MoveViewModel(moves: [pokeMove, pokeMove2])
        XCTAssertEqual(sut.name.count, 2)
        XCTAssertEqual(sut.name, ["poke_name_1", "poke_name_2"])
    }

    func testEmptyMovesShouldReturnNoNames() {
        let sut = MoveViewModel(moves: [])
        XCTAssertEqual(sut.name.count, 0)
    }
}
