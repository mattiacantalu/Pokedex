import XCTest
@testable import Pokedex

class StringNonEmptyTests: XCTestCase {
    func testShouldReturnNil_ifString_isNil() {
        let sut: String? = nil
        XCTAssertNil(sut?.nilIfEmpty)
    }

    func testShouldReturnNil_ifString_isEmpty() {
        let sut = ""
        XCTAssertNil(sut.nilIfEmpty)
    }

    func testShouldReturnItself_ifString_isNotEmpty() {
        let sut = "not empty string"

        let result = sut.nilIfEmpty

        XCTAssertNotNil(result)
        XCTAssertEqual(result, "not empty string")
    }

    func testShouldReturnNil_ifOptionalString_isNil() {
        let sut = Optional<String>.none
        XCTAssertNil(sut.nilIfEmpty)
    }

    func testShouldReturnNil_ifOptionalString_isEmpty() {
        let sut = Optional<String>.some("")
        XCTAssertNil(sut.nilIfEmpty)
    }

    func testShouldReturnItself_ifOptionalString_isNotEmpty() {
        let sut = Optional<String>.some("not empty string")

        let result = sut.nilIfEmpty

        XCTAssertNotNil(result)
        XCTAssertEqual(result, "not empty string")
    }
}
