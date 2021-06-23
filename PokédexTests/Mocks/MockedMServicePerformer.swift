import Foundation
import UIKit
@testable import Pokedex

class MockedMServicePerformer: MServicePerformerProtocol {
    var counterPokedex: Int = 0
    var counterNextPokedex: Int = 0
    var counterPokemon: Int = 0

    var pokedexHandler: ((Int, Int, @escaping ((Result<Pokedex, Error>) -> Void)) -> Void)?
    var nextPokedexHandler: ((String, @escaping ((Result<Pokedex, Error>) -> Void)) -> Void)?
    var pokemonHandler: ((String, @escaping ((Result<Pokemon, Error>) -> Void)) -> Void)?
    
    func pokedex(offset: Int,
                 limit: Int,
                 completion: @escaping ((Result<Pokedex, Error>) -> Void)) throws {
        counterPokedex += 1
        if let pokedexHandler = pokedexHandler {
            return pokedexHandler(offset, limit, completion)
        }
        completion(.failure(MockedError.generic))
    }

    func pokedex(next: String,
                 completion: @escaping ((Result<Pokedex, Error>) -> Void)) throws {
        counterNextPokedex += 1
        if let nextPokedexHandler = nextPokedexHandler {
            return nextPokedexHandler(next, completion)
        }
        completion(.failure(MockedError.generic))
    }

    func pokemon(by link: String,
                 completion: @escaping ((Result<Pokemon, Error>) -> Void)) throws {
        counterPokemon += 1
        if let pokemonHandler = pokemonHandler {
            return pokemonHandler(link, completion)
        }
        completion(.failure(MockedError.generic))
    }
}
