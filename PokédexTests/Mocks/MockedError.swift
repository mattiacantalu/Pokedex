import Foundation

enum MockedError: Error {
    case generic
    case fake
}

extension MockedError: Equatable {
    public static func == (lhs: MockedError, rhs: MockedError) -> Bool {
        switch (lhs, rhs) {
        case (.generic, .generic):
            return true
        case (.fake, .fake):
            return true
        default:
            return false
        }
    }
}
