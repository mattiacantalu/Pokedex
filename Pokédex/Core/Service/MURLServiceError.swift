import Foundation

enum MServiceError: Error {
    case noData
    case couldNotCreate(url: String?)
}
