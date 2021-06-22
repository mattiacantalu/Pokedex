import Foundation

class StatViewModel {
    private let stats: [PokeStat]

    var stat: [(name: String, value: Int)] {
        stats.map { ($0.stat.name, $0.value) }
    }

    init(stats: [PokeStat]) {
        self.stats = stats
    }
}
