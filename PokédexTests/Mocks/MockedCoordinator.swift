import Foundation
import UIKit
@testable import Pokedex

class MockedCoordinator: CoordinatorProtocol {
    var counterListController: Int = 0
    var counterDetailController: Int = 0
    var counterAsRoot: Int = 0
    var counterPush: Int = 0

    var listControllerHandler: (() -> UIViewController)?
    var detailControllerHandler: ((Poke) -> UIViewController)?
    var asRootHandler: ((UIViewController) -> Void)?
    var pushHandler: ((UIViewController, Any?) -> Void)?

    func listController() -> UIViewController {
        counterListController += 1
        if let listControllerHandler = listControllerHandler {
            return listControllerHandler()
        }
        return UIViewController()
    }

    func detailController(options: Poke) -> UIViewController {
        counterDetailController += 1
        if let detailControllerHandler = detailControllerHandler {
            return detailControllerHandler(options)
        }
        return UIViewController()
    }

    func asRoot(controller: UIViewController) {
        counterAsRoot += 1
        if let asRootHandler = asRootHandler {
            asRootHandler(controller)
        }
    }

    func push(controller: UIViewController, from sender: Any?) {
        counterPush += 1
        if let pushHandler = pushHandler {
            pushHandler(controller, sender)
        }
    }
}
