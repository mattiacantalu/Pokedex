import XCTest
@testable import Stargazers

class MURLCommandTests: XCTestCase {
    override func setUp() {}

    func configure(_ session: MURLSessionProtocol) -> MURLConfiguration {
        let service = MURLService(session: session,
                                   dispatcher: SyncDispatcher())
        return MURLConfiguration(service: service,
                                  baseUrl: "https://api.github.com")
    }
}

func == (lhs: MServiceError, rhs: MServiceError) -> Bool {
    switch (lhs, rhs) {
    case (let .couldNotCreate(url), let .couldNotCreate(url2)):
        return url == url2
    case (.noData, .noData):
        return true
    default:
        return false
    }
}
