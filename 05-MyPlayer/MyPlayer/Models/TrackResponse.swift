//
//  Response.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 7/1/21.
//

import Foundation

struct TrackResponse: Decodable {
    let message: TrackContent
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

struct TrackContent: Decodable {
    let body: TrackBody
    
    enum CodingKeys: String, CodingKey {
        case body = "body"
    }
}

 struct TrackBody: Decodable {
    let trackList: [Track]
    
    enum CodingKeys: String, CodingKey {
        case trackList = "track_list"
    }
}

 struct Track: Decodable {
    let track: TrackElement
    
    enum CodingKeys: String, CodingKey {
        case track = "track"
    }
}

 struct TrackElement: Decodable {
    let trackId: Int
    let trackName: String
    let artistName: String
    
    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case trackName = "track_name"
        case artistName = "artist_name"
    }
}
