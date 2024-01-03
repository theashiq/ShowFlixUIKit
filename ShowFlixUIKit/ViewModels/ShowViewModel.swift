//
//  ShowViewModel.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import Foundation

struct ShowViewModel{
    let title: String
    let posterUrl: URL?
    let show: Show
    
    static func get(from show: Show) -> ShowViewModel{
        return ShowViewModel(
            title: show.original_name ?? show.original_title ?? "Unknown Show Title",
            posterUrl: URL(string: "\(Constants.tmdbPosterBaseURL)/\(show.poster_path ?? "")"),
            show: show
        )
    }
}
