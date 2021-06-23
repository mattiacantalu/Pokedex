import XCTest
@testable import Pokedex

class SpriteViewModelTests: XCTestCase {
    private var sut: SpriteViewModels?
    private var service: MockedMImageDownloader?
    private var mockedImage: Data? {
        UIImage(named: "pokeball",
                in: Bundle(for: MImageDownloaderTests.self),
                with: .none)?
            .jpegData(compressionQuality: 1.0)
    }

    override func setUpWithError() throws {
        service = MockedMImageDownloader()
        sut = SpriteViewModels(service: try XCTUnwrap(service),
                               sprite: "https://sample.com/1")
    }

    func testImageDownloaded() {
        service?.downloadImageHandler = { url, completion in
            XCTAssertEqual(url, "https://sample.com/1")
            completion(self.mockedImage)
        }

        sut?.fetchImage(completion: {
            XCTAssertEqual($0, self.mockedImage)
            XCTAssertEqual(self.service?.counterDownloadImage, 1)
        })
    }

    func testImageDownloadedIsNil() {
        sut?.fetchImage(completion: {
            XCTAssertNil($0)
            XCTAssertEqual(self.service?.counterDownloadImage, 1)
        })
    }
}
