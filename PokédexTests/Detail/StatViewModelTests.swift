import XCTest
@testable import Pokedex

class StatViewModelTests: XCTestCase {
    func testStats() {
        let pokeStats = [PokeStat(stat: Poke(name: "poke_name_1", url: "poke_url_1"), value: 1)]
        let sut = StatViewModel(stats: pokeStats)
        XCTAssertEqual(sut.stat.count, 1)
        XCTAssertEqual(sut.stat.first?.name, "poke_name_1")
        XCTAssertEqual(sut.stat.first?.value, 1)
    }

    func testEmptyStatsShouldReturnNoStats() {
        let sut = StatViewModel(stats: [])
        XCTAssertEqual(sut.stat.count, 0)
    }
}
