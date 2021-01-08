//
//  ArtworkResponse.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 7/1/21.
//

import Foundation

struct ArtworkResponse: Decodable {
    let data: [DeezerTrack]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct DeezerTrack: Decodable {
    let album: DeezerAlbum
    
    enum CodingKeys: String, CodingKey {
        case album = "album"
    }
}

struct DeezerAlbum: Decodable {
    let coverUrl: String
    
    enum CodingKeys: String, CodingKey {
        case coverUrl = "cover_medium"
    }
}
