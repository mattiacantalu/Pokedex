import XCTest
@testable import Stargazers

class MImageDownloaderTests: XCTestCase {
    private var sut: MImageDownloader?
    private var cache: MockedCacheable?
    private var mockedImage: UIImage?

    override func setUp() {
        cache = MockedCacheable()
        do {
            mockedImage = UIImage(named: "sample", in: Bundle(for: MImageDownloaderTests.self), with: .none)
            let url = URL(string: "https://sampleurl.com")!
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: "1.0",
                                           headerFields: ["Content-Type": "image"])
            let session = MockedSession(data: try XCTUnwrap(mockedImage).jpegData(compressionQuality: 1.0),
                                        response: response,
                                        error: nil,
                                        completionRequest: { _ in })
            let service = MURLService(session: try XCTUnwrap(session),
                                      dispatcher: SyncDispatcher())
            sut = MImageDownloader(service: service, cache: try XCTUnwrap(cache))
        } catch { XCTFail("Expected success. Got \(error)") }
    }

    func testDownloadImage_withCache_shouldReturnCachedImg() {
        cache?.getHandler = {
            XCTAssertEqual($0, "https://sampleurl.com")
            return self.mockedImage
        }

        sut?.downloadImage(from: "https://sampleurl.com",
                           completion: {
                            XCTAssertEqual($0, self.mockedImage)
                            XCTAssertEqual(self.cache?.counterGet, 1)
                            XCTAssertEqual(self.cache?.counterSet, 0)
                           })
    }

    func testDownloadImage_withNocCache_shouldReturnNewImg() {
        cache?.getHandler = {
            XCTAssertEqual($0, "https://sampleurl.com")
            return nil
        }

        sut?.downloadImage(from: "https://sampleurl.com",
                           completion: {
                            XCTAssertNotNil($0)
                            XCTAssertEqual(self.cache?.counterGet, 1)
                            XCTAssertEqual(self.cache?.counterSet, 1)
                           })
    }
}
