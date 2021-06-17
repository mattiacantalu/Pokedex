import Foundation

struct MURLConfiguration {
    let service: MURLService
    let baseUrl: String

    init(service: MURLService,
         baseUrl: String) {
        self.service = service
        self.baseUrl = baseUrl
    }
}
