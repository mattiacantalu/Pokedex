import XCTest
@testable import Pokedex

class CoordinatorTests: XCTestCase {
    var sut: AppCoordinator?

    override func setUp() {
        sut = AppCoordinator(window: nil,
                             configuration: MURLConfiguration(service: MURLService(),
                                                              baseUrl: "base_url"))
    }

    func testController_shouldBe_ListController() throws {
        let controller = sut?.listController() as? UINavigationController
        XCTAssertTrue(controller?.viewControllers.first is ListViewController)
    }

    func testController_shouldBe_DetailController() throws {
        let controller = sut?.detailController(options: Poke(name: "", url: ""))
        XCTAssertTrue(controller is DetailViewController)
    }

    func testController_shoulBe_setAsRoot() {
        let window = UIWindow()
        sut = AppCoordinator(window: window,
                             configuration: MURLConfiguration(service: MURLService(),
                                                              baseUrl: "base_url"))
        let controller = UIViewController()
        sut?.asRoot(controller: controller)

        XCTAssertEqual(window.rootViewController, controller)
    }
}
