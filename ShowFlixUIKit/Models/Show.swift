//
//  Show.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import Foundation

struct ShowApiResponse: Codable {
    let results: [Show]
}

struct Show: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
    var title: String{
        original_name ?? original_title ?? "Unknown Show Title"
    }
    var posterUrl: URL?{
        URL(string: "\(Constants.tmdbPosterBaseURL)/\(poster_path ?? "")")
    }
}
