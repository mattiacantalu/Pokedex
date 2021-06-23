import Foundation

class AbilityViewModel {
    private let abilities: [PokeAbility]

    var names: [String] {
        abilities.map { $0.ability.name }
    }

    init(abilities: [PokeAbility]) {
        self.abilities = abilities
    }
}
