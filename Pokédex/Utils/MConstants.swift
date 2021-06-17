struct MConstants {
    struct URL {
        struct Component {
            static let repos = "repos"
            static let stargazers = "stargazers"
        }
        struct Query {
            static let page = "page"
            static let perPage = "per_page"
        }
        static let urlProtocol = "https"
        static let base = "https://api.github.com"
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
