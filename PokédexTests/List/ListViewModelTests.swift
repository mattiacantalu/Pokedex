import XCTest
@testable import Pokedex

class ListViewModelTest: XCTestCase {
    private var sut: ListViewModel?
    private var imageDownloader: MockedMImageDownloader?
    private var service: MockedMServicePerformer?
    private var coordinator: MockedCoordinator?

    override func setUpWithError() throws {
        coordinator = MockedCoordinator()
        imageDownloader = MockedMImageDownloader()
        service = MockedMServicePerformer()
        sut = ListViewModel(service: try XCTUnwrap(service),
                            imageDownloader: try XCTUnwrap(imageDownloader),
                            coordinator: try XCTUnwrap(coordinator))
    }
}

extension ListViewModelTest {
    func testFetch_withSucceededService_shouldSucceed() throws {
        service?.pokedexHandler = { offset, limit, completion in
            XCTAssertEqual(offset, 0)
            XCTAssertEqual(limit, 20)
            completion(.success(Pokedex.mock))
        }

        XCTAssertEqual(sut?.viewModel.count, 0)
        
        sut?.fetch(success: {
            XCTAssertEqual($0.count, 1)
            XCTAssertEqual($0.first?.name, "poke_name")
        }, failure: { XCTFail("Expected success. Got \($0)") })
        
        XCTAssertEqual(service?.counterPokedex, 1)
        XCTAssertEqual(sut?.viewModel.count, 1)
    }

    func testFetch_withFailureService_shouldFail() throws {
        service?.pokedexHandler = { offset, limit, completion in
            XCTAssertEqual(offset, 0)
            XCTAssertEqual(limit, 20)
            completion(.failure(MockedError.fake))
        }

        sut?.fetch(success: { _ in XCTFail("Expected fail. Got success!") },
                   failure: { XCTAssertEqual($0 as? MockedError, MockedError.fake) })

        XCTAssertEqual(service?.counterPokedex, 1)
        XCTAssertEqual(sut?.viewModel.count, 0)
    }
}

extension ListViewModelTest {
    func testFetchNext_withSucceededService_shouldSucceed() throws {
        service?.pokedexHandler = { _, _, completion in
            completion(.success(Pokedex.mock))
        }
        service?.nextPokedexHandler = { url, completion in
            XCTAssertEqual(url, "next_url")
            completion(.success(Pokedex.mock))
        }

        XCTAssertEqual(sut?.viewModel.count, 0)

        sut?.fetch(success: { _ in }, failure: { _ in })

        XCTAssertEqual(sut?.viewModel.count, 1)

        sut?.fetchNext(success: {
            XCTAssertEqual($0.count, 2)
            XCTAssertEqual($0.first?.name, "poke_name")
            XCTAssertEqual($0.last?.name, "poke_name")
        }, failure: { XCTFail("Expected success. Got \($0)") })

        XCTAssertEqual(service?.counterNextPokedex, 1)
        XCTAssertEqual(sut?.viewModel.count, 2)
    }

    func testFetchNext_withFailureService_shouldFail() throws {
        service?.nextPokedexHandler = { _, completion in
            completion(.failure(MockedError.fake))
        }

        sut?.fetchNext(success: { _ in XCTFail("Expected fail. Got success!") },
                       failure: { XCTAssertEqual($0 as? MockedError, MockedError.fake) })
        XCTAssertEqual(service?.counterNextPokedex, 1)
        XCTAssertEqual(sut?.viewModel.count, 0)
    }
}

extension ListViewModelTest {
    func testShowPokemon() {
        let final = UIViewController()
        let sender = UIViewController()

        coordinator?.detailControllerHandler = {
            XCTAssertEqual($0.name, "name")
            XCTAssertEqual($0.url, "poke_url")
            return final
        }
        coordinator?.pushHandler = {
            XCTAssertEqual($0, final)
            XCTAssertEqual($1 as? UIViewController, sender)
        }

        sut?.show(pokemon: Poke(name: "name", url: "poke_url"),
                  sender: sender)

        XCTAssertEqual(coordinator?.counterPush, 1)
    }
}

private extension Pokedex {
    static var mock: Pokedex {
        Pokedex(next: "next_url",
                results: [Poke(name: "poke_name", url: "poke_url")])
    }
}
