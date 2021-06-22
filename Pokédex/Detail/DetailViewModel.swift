import Foundation

class DetailViewModel {
    private let service: MServicePerformerProtocol
    private let imageDownloader: MImageProtocol
    private let poke: Poke

    private var pokemon: Pokemon?

    var abiltyViewModel: AbilityViewModel {
        AbilityViewModel(abilities: pokemon?.abilities ?? [])
    }
    var moveViewModel: MoveViewModel {
        MoveViewModel(moves: pokemon?.moves ?? [])
    }
    var typeViewModel: TypeViewModel {
        TypeViewModel(types: pokemon?.types ?? [])
    }
    var statViewModel: StatViewModel {
        StatViewModel(stats: pokemon?.stats ?? [])
    }
    var spritesViewModel: [SpriteViewModels] {
        [pokemon?.images.front, pokemon?.images.back]
            .compactMap { $0 }
            .map { image in SpriteViewModels(service: imageDownloader,
                                             sprite: image) }
    }
    var name: String {
        pokemon.map { $0.name }.notNil
    }
    var weight: String {
        pokemon.map { $0.weight.stringValue }.notNil
    }
    var height: String {
        pokemon.map { $0.height.stringValue }.notNil
    }

    init(service: MServicePerformerProtocol,
         imageDownloader: MImageProtocol,
         poke: Poke) {
        self.service = service
        self.imageDownloader = imageDownloader
        self.pokemon = nil
        self.poke = poke
    }
}

extension DetailViewModel {
    func fetch(success: @escaping (DetailViewModel) -> Void,
               failure: @escaping (Error) -> Void) {
        performTry({ try service.pokemon(by: poke.url) { result in
            switch result {
            case .success(let response):
                self.pokemon = response
                success(self)
            case .failure(let error):
                failure(error)
            }
        }
        }, fallback: { failure($0) })
    }
}

private extension Int {
    var stringValue: String {
        String(self)
    }
}
