struct MConstants {
    struct URL {
        struct Component {
            static let pokemon = "pokemon"
        }

        struct Query {
            static let limit = "limit"
            static let offset = "offset"
        }
        
        static let urlProtocol = "https"
        static let base = "https://pokeapi.co/api/v2/"
        static let sprites = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        static let statusCodeOk = 200
        static let statusCodemultipleChoice = 300
    }

    struct Error {
        static let responseError = "An error has occurred"
        static let noData = "No data fetched"
    }

    struct Cache {
        static let expiration = 3600
    }
}
