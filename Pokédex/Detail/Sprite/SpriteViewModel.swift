import Foundation

class SpriteViewModels {
    private let sprite: String
    private let service: MImageProtocol

    init(service: MImageProtocol,
         sprite: String) {
        self.service = service
        self.sprite = sprite
    }

    func fetchImage(completion: @escaping (Data?) -> Void) {
        service.downloadImage(from: sprite) { data in
            completion(data)
        }
    }
}
