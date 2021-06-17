import Foundation

extension Result where Success == MError {
    func mapError<T: Decodable>(code: Int) -> (Result<T, Error>) {
        switch self {
        case .success(_):
            return .failure(NSError(domain: "",
                                    code: code,
                                    userInfo: nil))
        case .failure(let error):
            return .failure(error)
        }
    }
}
