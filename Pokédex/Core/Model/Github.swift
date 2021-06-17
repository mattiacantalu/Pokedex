import Foundation

struct MStargazer: Codable {
    let user: String
    let avatar: String?

    private enum CodingKeys : String, CodingKey {
        case user = "login",
             avatar = "avatar_url"
    }
}
struct MError: Codable {
    let message: String
    let docs: String

    private enum CodingKeys : String, CodingKey {
        case message = "message",
             docs = "documentation_url"
    }
}
