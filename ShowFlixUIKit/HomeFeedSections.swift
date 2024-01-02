//
//  HomeFeedSections.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import Foundation

enum HomeFeedSections: String, CaseIterable {
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
