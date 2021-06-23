import Foundation

class ListViewModel {
    private let service: MServicePerformerProtocol
    private let imageDownloader: MImageProtocol
    private let coordinator: CoordinatorProtocol
    private var pokedex: Pokedex?

    private(set) var viewModel: [ListCellViewModel] = []

    init(service: MServicePerformerProtocol,
         imageDownloader: MImageProtocol,
         coordinator: CoordinatorProtocol) {
        self.service = service
        self.imageDownloader = imageDownloader
        self.coordinator = coordinator
    }
}

extension ListViewModel {
    func fetch(success: @escaping ([ListCellViewModel]) -> Void,
               failure: @escaping (Error) -> Void) {
        performTry({ try service.pokedex() {
            [weak self] in self?.manage(response: $0, success: success, failure: failure) }
        }, fallback: { failure($0) })
    }

    func fetchNext(success: @escaping ([ListCellViewModel]) -> Void,
                   failure: @escaping (Error) -> Void) {
        performTry({ try service.pokedex(next: pokedex.flatMap { $0.next }.notNil ) {
            [weak self] in self?.manage(response: $0, success: success, failure: failure) }
        }, fallback: { failure($0) })
    }

    private func manage(response: Result<Pokedex, Error>,
                        success: @escaping ([ListCellViewModel]) -> Void,
                        failure: @escaping (Error) -> Void) {
        switch response {
        case .success(let response):
            success(self.onSuccess(pokedex: response))
        case .failure(let error):
            failure(error)
        }
    }
}

extension ListViewModel {
    func show(pokemon: Poke, sender: Any?) {
        let controller = coordinator.detailController(options: pokemon)
        coordinator.push(controller: controller, from: sender)
    }
}

private extension ListViewModel {
    func onSuccess(pokedex: Pokedex) -> [ListCellViewModel] {
        let models = pokedex.results.map { ListCellViewModel(service: imageDownloader,
                                                             pokeModel: $0) }
        viewModel = viewModel + models
        self.pokedex = pokedex
        return viewModel
    }
}
