//
//  PreviewViewModel.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import Foundation

struct PreviewViewModel{
    
    let previewMedia: PreviewMedia
    
    var url: URL?{
        URL(string: "\(Constants.youtubeBaseMediaUrl)/\(previewMedia.id.videoId)")
    }
    
    static func get(from previewMedia: PreviewMedia) -> PreviewViewModel{
        return PreviewViewModel(previewMedia: previewMedia)
    }
}
