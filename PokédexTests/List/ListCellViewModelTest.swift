import XCTest
@testable import Pokedex

class ListCellViewModelTest: XCTestCase {
    private var sut: ListCellViewModel?
    private var service: MockedMImageDownloader?
    private var mockedImage: Data? {
        UIImage(named: "pokeball",
                in: Bundle(for: MImageDownloaderTests.self),
                with: .none)?
            .jpegData(compressionQuality: 1.0)
    }

    override func setUpWithError() throws{
        service = MockedMImageDownloader()
        sut = ListCellViewModel(service: try XCTUnwrap(service),
                                pokeModel: Poke(name: "name",
                                                url: "https://sample.com/1"))
    }

    func testGetName() {
        XCTAssertEqual(sut?.name, "name")
    }

    func testOpenModel() {
        sut?.open(completion: {
            XCTAssertEqual($0.name, "name")
            XCTAssertEqual($0.url, "https://sample.com/1")
        })
    }

    func testFetchImage_withCorrectUrl_shouldDownloadImage() {
        service?.downloadImageHandler = { link, completion in
            XCTAssertEqual(link, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
            completion(self.mockedImage)
        }

        sut?.fetchImage(completion: {
            XCTAssertNotNil($0)
            XCTAssertEqual($0, self.mockedImage)
            XCTAssertEqual(self.service?.counterDownloadImage, 1)
        })
    }
    
    func testFetchImage_withIncorrectUrl_shouldNotDownloadImage() throws {
        sut = ListCellViewModel(service: try XCTUnwrap(service),
                                pokeModel: Poke(name: "name",
                                                url: ""))
        sut?.fetchImage(completion: {
            XCTAssertNil($0)
            XCTAssertEqual(self.service?.counterDownloadImage, 0)
        })
    }
}
