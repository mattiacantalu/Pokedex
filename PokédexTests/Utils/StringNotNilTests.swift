import XCTest
@testable import Pokedex

class StringNotNilTests: XCTestCase {
    func testShouldReturnEmptyString_ifString_isNil() {
        let sut: String? = nil
        XCTAssertEqual(sut.notNil, "")
    }

    func testShouldReturnItself_ifString_isNotEmpty() {
        let sut: String? = "not empty string"

        let result = sut.notNil

        XCTAssertNotNil(result)
        XCTAssertEqual(result, "not empty string")
    }
}
