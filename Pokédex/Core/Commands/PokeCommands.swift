import Foundation

extension MServicePerformerProtocol {
    func pokedex(offset: Int = 20,
                 limit: Int = 10,
                 completion: @escaping ((Result<Pokedex, Error>) -> Void)) throws {
        return try pokedex(offset: offset, limit: limit, completion: completion)
    }
}

extension MServicePerformer: MServicePerformerProtocol {
    func pokedex(offset: Int,
                 limit: Int,
                 completion: @escaping ((Result<Pokedex, Error>) -> Void)) throws {

        guard let url = baseUrl else {
            completion(.failure(MServiceError.couldNotCreate(url: baseUrl?.absoluteString)))
            return
        }

        let request = { () -> MURLRequest in
            MURLRequest
                .get(url: url)
                .with(component: MConstants.URL.Component.pokemon)
                .appendQuery(name: MConstants.URL.Query.offset, value: offset.stringValue)
                .appendQuery(name: MConstants.URL.Query.limit, value: limit.stringValue)
        }

        try makeRequest(request(),
                        map: Pokedex.self,
                        completion: completion)
    }

    func pokedex(next: String,
                 completion: @escaping ((Result<Pokedex, Error>) -> Void)) throws {

        guard let url = URL(string: next) else {
            completion(.failure(MServiceError.couldNotCreate(url: next)))
            return
        }

        let request = { () -> MURLRequest in
            MURLRequest.get(url: url)
        }

        try makeRequest(request(),
                        map: Pokedex.self,
                        completion: completion)
    }

    func pokemon(by link: String,
                 completion: @escaping ((Result<Pokemon, Error>) -> Void)) throws {

        guard let url = URL(string: link) else {
            completion(.failure(MServiceError.couldNotCreate(url: link)))
            return
        }

        let request = { () -> MURLRequest in
            MURLRequest.get(url: url)
        }

        try makeRequest(request(),
                        map: Pokemon.self,
                        completion: completion)
    }
}

private extension Int {
    var stringValue: String {
        String(self)
    }
}
