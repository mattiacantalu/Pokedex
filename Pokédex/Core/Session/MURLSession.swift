import Foundation

protocol MURLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func dataTask(with url: URL,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

struct MURLSession: MURLSessionProtocol {
    private let session: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        session = urlSession
    }

    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request) { responseData, urlResponse, responseError in
            completion(responseData, urlResponse, responseError)
        }
        task.resume()
    }

    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: url) { responseData, urlResponse, responseError in
            completion(responseData, urlResponse, responseError)
        }
        task.resume()
    }
}
