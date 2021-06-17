import Foundation
@testable import Stargazers

class MockedCacheable: MCacheable {
    var counterSet: Int = 0
    var counterGet: Int = 0

    var setHandler: ((Any, String) -> Void)?
    var getHandler: ((String) -> AnyObject?)?

    public init() {}

    func set(obj: Any, for key: String) {
        counterSet += 1
        if let setHandler = setHandler {
            return setHandler(obj, key)
        }
    }

    func object(for key: String) -> AnyObject? {
        counterGet += 1
        if let getHandler = getHandler {
            return getHandler(key)
        }
        return nil
    }
}
