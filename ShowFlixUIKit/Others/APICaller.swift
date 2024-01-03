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
    static let youtubeApiKey = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let youtubeBaseMediaUrl = "https://www.youtube.com/embed"
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
                let results = try JSONDecoder().decode(ShowApiResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    
    func getPreviewMedia(for query: String, completion: @escaping (Result<PreviewMedia, APIError>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youtubeApiKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(PreviewMediaResponse.self, from: data)
                
                completion(.success(results.items[0]))
                

            } catch {
                completion(.failure(.failedToGetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
