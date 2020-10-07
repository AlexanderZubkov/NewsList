import Foundation
import XMLCoder

enum APIError: Error {
    case wrongURL(String)
    case requestError(String)
    case noData
    case decodingError
}

final class APIClient {
    public func loadRedditData(_ completion: @escaping (Result<[Entry], APIError>) -> Void) {
        let url = Constants.URL.reddit.rawValue

        request(urlString: url) { (_ result: Result<Feed, APIError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let feed):
                let entries = feed.entry
                completion(.success(entries))
            }
        }
    }

    public func loadAppleData(_ completion: @escaping (Result<[Item], APIError>) -> Void) {
        let url = Constants.URL.apple.rawValue

        request(urlString: url) { (_ result: Result<Rss, APIError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let rss):
                let items = rss.channel.item
                completion(.success(items))
            }
        }
    }

    private func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>)->Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.wrongURL(urlString)))
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error -> Void in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.requestError(error.localizedDescription)))
                }
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decoded = try XMLDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }
            catch let error {
                completion(.failure(.decodingError))
                debugPrint("decoding error: \(error.localizedDescription)")
            }
        }).resume()
    }
}
