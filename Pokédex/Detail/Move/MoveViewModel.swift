import Foundation

class MoveViewModel {
    private let moves: [PokeMove]

    var name: [String] {
        moves.map { $0.move.name }
    }

    init(moves: [PokeMove]) {
        self.moves = moves
    }
}
