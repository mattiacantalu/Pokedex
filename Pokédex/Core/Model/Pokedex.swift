import Foundation

struct Pokedex: Codable {
    let next: String
    let results: [Poke]
}
    
struct Pokemon: Codable {
    let name: String
    let experience: Int
    let weight: Int
    let height: Int
    let abilities: [PokeAbility]
    let moves: [PokeMove]
    let types: [PokeType]
    let stats: [PokeStat]
    let images: PokeImages

    private enum CodingKeys : String, CodingKey {
        case name = "name",
             experience = "base_experience",
             weight = "weight",
             height = "height",
             abilities = "abilities",
             moves = "moves",
             types = "types",
             stats = "stats",
             images = "sprites"
    }
}

struct PokeImages: Codable {
    let back: String?
    let front: String?

    private enum CodingKeys : String, CodingKey {
        case back = "back_default",
             front = "front_default"
    }
}

struct PokeType: Codable {
    let type: Poke
}

struct PokeAbility: Codable {
    let ability: Poke
}

struct PokeStat: Codable {
    let stat: Poke
    let value: Int

    private enum CodingKeys : String, CodingKey {
        case stat = "stat",
             value = "base_stat"
    }
}

struct PokeMove: Codable {
    let move: Poke
}

struct Poke: Codable {
    let name: String
    let url: String
}

struct MError: Codable {}
