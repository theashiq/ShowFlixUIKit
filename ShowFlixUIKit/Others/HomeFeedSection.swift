//
//  HomeFeedSection.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import Foundation

enum HomeFeedSection: String, CaseIterable {
    case trendingMovies, popular, trendingTV, upcomingMovies, topRated
    
    var rawValue: String{
        switch self{
        case .trendingMovies: return "Trending Movies"
        case .popular: return "Popular"
        case .trendingTV: return "Trending TV"
        case .upcomingMovies: return "Upcoming Movies"
        case .topRated: return "Top Rated"
        }
    }
}

extension HomeFeedSection{
    private var tmdbURL: URL?{
        switch self{
            
        case .trendingMovies:
            return URL(string: "\(Constants.tmdbBaseURL)/3/trending/movie/day?api_key=\(Constants.tmdbApiKey)")
        case .popular:
            return URL(string: "\(Constants.tmdbBaseURL)/3/movie/popular?api_key=\(Constants.tmdbApiKey)&language=en-US&page=1")
        case .trendingTV:
            return URL(string: "\(Constants.tmdbBaseURL)/3/trending/tv/day?api_key=\(Constants.tmdbApiKey)")
        case .upcomingMovies:
            return URL(string: "\(Constants.tmdbBaseURL)/3/movie/upcoming?api_key=\(Constants.tmdbApiKey)&language=en-US&page=1")
        case .topRated:
            return URL(string: "\(Constants.tmdbBaseURL)/3/movie/top_rated?api_key=\(Constants.tmdbApiKey)&language=en-US&page=1")
        }
    }
    
    func getShows(completion: @escaping (Result<[Show], APIError>) -> Void) {
        APICaller.shared.getShows(url: self.tmdbURL, completion: completion)
    }
}
