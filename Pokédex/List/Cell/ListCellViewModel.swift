import Foundation

class ListCellViewModel {
    private let service: MImageProtocol
    private let pokeModel: Poke

    init(service: MImageProtocol,
         pokeModel: Poke) {
        self.service = service
        self.pokeModel = pokeModel
    }

    var name: String {
        pokeModel.name
    }

    private var url: String {
        pokeModel.url
    }

    func open(completion: (Poke) -> Void) {
        completion(pokeModel)
    }

    func fetchImage(completion: @escaping (Data?) -> Void) {
        url
            .components(separatedBy: "/")
            .lazy
            .filter { !$0.isEmpty }
            .last
            .nilIfEmpty
            .fold(some: { [weak self] in
                self?.download(from: "\(MConstants.URL.sprites)\($0).png",
                               completion: completion)
            }, none: { completion(nil) })
    }

    private func download(from url: String,
                          completion: @escaping (Data?) -> Void) {
        service.downloadImage(from: url) { completion($0) }
    }
}
