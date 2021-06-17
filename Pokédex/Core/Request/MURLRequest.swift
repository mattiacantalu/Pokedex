import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct MURLRequest {
    let url: URL
    let method: HTTPMethod

    private init(url: URL,
                 method: HTTPMethod) {
        self.url = url
        self.method = method
    }

    static func get(url: URL) -> MURLRequest {
        MURLRequest(url: url,
                    method: .get)
    }
}

extension MURLRequest {
    func with(component: String) -> MURLRequest {
        MURLRequest(url: url.appendingPathComponent(component),
                    method: self.method)
    }

    func appendQuery(name: String, value: String?) -> MURLRequest {
        appendingQuery(item: URLQueryItem(name: name, value: value))
    }

    private func appendingQuery(item: URLQueryItem) -> MURLRequest {
        guard let baseUrl = URLComponents(url: url)?.appendingQueryItem(item).url else {
            return MURLRequest(url: self.url,
                               method: self.method)
        }
        return MURLRequest(url: baseUrl,
                           method: self.method)
    }

    func build() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

private extension URLComponents {
    func appendingQueryItem(_ item: URLQueryItem) -> URLComponents {
        appendingQueryItems([item])
    }

    func appendingQueryItems(_ items: [URLQueryItem]) -> URLComponents {
        var components = self
        components.queryItems = components.queryItems ?? [URLQueryItem]()
        components.queryItems? += items

        return components
    }
}

private extension URLComponents {
    init?(url: URL) {
        self.init(url: url, resolvingAgainstBaseURL: false)
    }
}
