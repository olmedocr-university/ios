//
//  LyricsResponse.swift
//  MyPlayer
//
//  Created by Raul Olmedo on 8/1/21.
//

import Foundation

struct LyricsResponse: Decodable {
    let message: LyricsContent
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

struct LyricsContent: Decodable {
    let body: Lyrics
    
    enum CodingKeys: String, CodingKey {
        case body = "body"
    }
}

 struct Lyrics: Decodable {
    let lyrics: LyricsBody
    
    enum CodingKeys: String, CodingKey {
        case lyrics = "lyrics"
    }
 }

struct LyricsBody: Decodable {
   let lyricsBody: String
   
   enum CodingKeys: String, CodingKey {
       case lyricsBody = "lyrics_body"
   }
}

