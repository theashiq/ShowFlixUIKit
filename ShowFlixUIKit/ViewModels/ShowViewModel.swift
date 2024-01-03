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
    
    let show: Show
    
    static func get(from show: Show) -> ShowViewModel{
        return ShowViewModel(show: show)
    }
}
