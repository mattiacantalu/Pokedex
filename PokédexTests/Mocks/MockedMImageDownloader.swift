import Foundation
@testable import Pokedex

class MockedMImageDownloader: MImageProtocol {
    var counterDownloadImage: Int = 0
    var downloadImageHandler: ((String?, @escaping (_ image: Data?) -> Void) -> Void)?

    func downloadImage(from link: String?,
                       completion: @escaping (_ image: Data?) -> Void) {
        counterDownloadImage += 1
        if let downloadImageHandler = downloadImageHandler {
            return downloadImageHandler(link, completion)
        }
        completion(nil)
    }
}
