//
//  ShowViewModel.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import Foundation

struct ShowViewModel{
    var title: String{
        show.title
    }
    var posterUrl: URL?{
        show.posterUrl
    }
    var description: String{
        show.overview ?? ""
    }
    
    let show: Show
    var wishListItem: Bool = false
    
    static func get(from show: Show) -> ShowViewModel{
        return ShowViewModel(show: show)
    }
}
