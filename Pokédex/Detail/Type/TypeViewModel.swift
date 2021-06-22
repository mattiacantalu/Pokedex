import Foundation

class TypeViewModel {
    private let types: [PokeType]

    var name: [String] {
        types.map { $0.type.name }
    }

    init(types: [PokeType]) {
        self.types = types
    }
}
