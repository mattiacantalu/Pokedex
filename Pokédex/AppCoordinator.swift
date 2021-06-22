//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Mattia Cantalù on 20/06/21.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    func listRootController() -> UIViewController
    func detailController(options: Poke) -> UIViewController
    func asRoot(controller: UIViewController)
    func push(controller: UIViewController, from sender: Any?)
}

class AppCoordinator: CoordinatorProtocol {
    private let configuration: MURLConfiguration
    private let window: UIWindow?

    init(window: UIWindow?,
         configuration: MURLConfiguration) {
        self.window = window
        self.configuration = configuration
    }

    func listRootController() -> UIViewController {
        let imageDownloader = MImageDownloader(service: configuration.service,
                                               cache: MCacheService())
        let service = MServicePerformer(configuration: configuration)
        let viewModel = ListViewModel(service: service,
                                      imageDownloader: imageDownloader,
                                      coordinator: self)
        let controller = ListViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: controller)
    }

    func detailController(options: Poke) -> UIViewController {
        let imageDownloader = MImageDownloader(service: configuration.service,
                                               cache: MCacheService())
        let service = MServicePerformer(configuration: configuration)
        let viewModel = DetailViewModel(service: service,
                                        imageDownloader: imageDownloader,
                                        poke: options)
        let controller = DetailViewController(viewModel: viewModel)
        return controller
    }

    func asRoot(controller: UIViewController) {
        window?.rootViewController = controller
    }

    func push(controller: UIViewController, from sender: Any?) {
        (sender as? UIViewController)?
            .navigationController?
            .pushViewController(controller, animated: true)
    }
}
