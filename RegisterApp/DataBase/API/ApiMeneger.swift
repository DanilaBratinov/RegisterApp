import Foundation

enum ApiType {
    case login
    case getUsers
    case getPosts
    case getAlbums
    
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com/posts"
    }
    
    var headers: [String: String] {
        switch self {
        case .login:
            return ["authToken": "12345"]
        default:
            return [:]
        }
    }
    var path: String {
        switch self {
        case . login: return "login"
        case .getUsers: return "users"
        case .getPosts: return "posts"
        case .getAlbums: return "albums"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        switch self {
        case .login:
            request.httpMethod = "POST"
            return request
        default:
            request.httpMethod = "GET"
            return request
        }
    }
}

class ApiMeneger {
    
    static let shared = ApiMeneger()
    
    func getUsers(completion: @escaping (Users) -> Void) {
        let request = ApiType.getUsers.request
        let _: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let users = try? JSONDecoder().decode(Users.self, from: data) {
                completion(users)
            } else {
                completion([])
            }
        }.resume()
    }
}
