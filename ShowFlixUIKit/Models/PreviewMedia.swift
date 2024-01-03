//
//  PreviewMedia.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import Foundation

struct PreviewMediaResponse: Codable {
    let items: [PreviewMedia]
}

struct PreviewMedia: Codable {
    let id: PreviewMediaId
}

struct PreviewMediaId: Codable {
    let kind: String
    let videoId: String
}
