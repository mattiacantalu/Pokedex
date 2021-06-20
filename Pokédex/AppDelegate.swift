import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let coordinator = AppCoordinator(window: window,
                    configuration: PokedexSession.configuration)
        coordinator.asRoot(controller: coordinator.listRootController())
        
        return true
    }
}

enum PokedexSession {
    static var configuration = MURLConfiguration(service: MURLService(),
                                                 baseUrl: MConstants.URL.base)
}
