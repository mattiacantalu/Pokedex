import Foundation

protocol MURLServiceProtocol {
    func performTask(with request: URLRequest,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func performTask(with url: URL,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

struct MURLService {
    private let session: MURLSessionProtocol
    private let dispatcher: Dispatcher

    init(session: MURLSessionProtocol = MURLSession(),
         dispatcher: Dispatcher = DefaultDispatcher()) {
        self.session = session
        self.dispatcher = dispatcher
    }
}

extension MURLService: MURLServiceProtocol {
    func performTask(with request: URLRequest,
                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { responseData, urlResponse, responseError in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }

    func performTask(with url: URL,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: url) { responseData, urlResponse, responseError in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }
}
