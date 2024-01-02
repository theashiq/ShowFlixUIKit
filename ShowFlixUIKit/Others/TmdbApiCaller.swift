//
//  TmdbApiCaller.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import Foundation


struct Constants {
    static let tmdbApiKey = "697d439ac993538da4e3e60b54e762cd"
    static let tmdbBaseURL = "https://api.themoviedb.org"
    static let tmdbPosterBaseURL = "https://image.tmdb.org/t/p/w500"

}

enum APIError: Error, LocalizedError {
    case failedToGetData
    
    var errorDescription: String?{
        NSLocalizedString("Failed to retrieve data from server", comment: "")
    }
}

class APICaller {
    
    static let shared = APICaller()
    
    private init(){}
    
    
    func getShows(url: URL?, completion: @escaping (Result<[Show], APIError>) -> Void) {
        guard let url else {
            completion(.failure(.failedToGetData))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.failedToGetData))
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingShowResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
}
