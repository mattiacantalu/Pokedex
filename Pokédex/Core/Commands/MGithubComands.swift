import Foundation

struct MUser {
    let name: String
    let repo: String
}

extension MServicePerformer: MServicePerformerProtocol {
    func stargazers(for user: MUser,
                    page: Int,
                    completion: @escaping ((Result<[MStargazer], Error>) -> Void)) throws {

        guard let url = baseUrl else {
            completion(.failure(MServiceError.couldNotCreate(url: baseUrl?.absoluteString)))
            return
        }

        let request = { () -> MURLRequest in
            MURLRequest
                .get(url: url)
                .with(component: MConstants.URL.Component.repos)
                .with(component: user.name)
                .with(component: user.repo)
                .with(component: MConstants.URL.Component.stargazers)
                .appendQuery(name: MConstants.URL.Query.perPage, value: "20")
                .appendQuery(name: MConstants.URL.Query.page, value: page.stringValue)
        }

        try makeRequest(request(),
                        map: [MStargazer].self,
                        completion: completion)
    }
}

private extension Int {
    var stringValue: String {
        String(self)
    }
}
