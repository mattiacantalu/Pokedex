import XCTest
@testable import Pokedex

class FoldTests: XCTestCase {
    func testFoldWithValue() {
        let some = Swift.Optional.some("test")
        let functions = MockedFunctions()

        let result = some.fold(some: functions.getFiveIfInputIsTest,
                               none: functions.getFour)

        XCTAssertEqual(result, 5)
    }

    func testFoldWithNoValue() {
        let some: String? = Swift.Optional.none
        let functions = MockedFunctions()

        let result = some.fold(some: functions.getFiveIfInputIsTest,
                               none: functions.getFour)

        XCTAssertEqual(result, 4)
    }

    func testFoldWithOperationFunctionAndValue() {
        let some = Swift.Optional.some("some string")
        let functions = MockedFunctions()

        some.fold(some: functions.functionInputString,
                  none: { functions.functionDefault() })

        XCTAssertEqual(functions.counterFunctionInputString, 1)
        XCTAssertEqual(functions.counterFunctionDefault, 0)
    }

    func testFoldWithOperationFunctionWithoutValue() {
        let some: String? = Swift.Optional.none
        let functions = MockedFunctions()

        some.fold(some: functions.functionInputString,
                  none: { functions.functionDefault() })

        XCTAssertEqual(functions.counterFunctionInputString, 0)
        XCTAssertEqual(functions.counterFunctionDefault, 1)
    }
}

class MockedFunctions {
    var counterFunctionInputString: Int = 0
    var counterFunctionDefault: Int = 0

    func getFiveIfInputIsTest(_ input: String) -> Int {
        if input == "test" {
            return 5
        }
        return 42
    }

    func getFour() -> Int {
        4
    }

    func functionInputString(_ some: String) {
        counterFunctionInputString += 1
    }

    func functionDefault() {
        counterFunctionDefault += 1
    }
}
