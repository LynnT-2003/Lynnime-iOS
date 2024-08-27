//
//  LNAnime.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import Foundation

struct Anime: Codable {
    let malID: Int?
    let url: String?
    let images: Images
    let trailer: Trailer?
    let approved: Bool?
    let titles: [Title]?
    let title: String?
    let titleEnglish: String?
    let titleJapanese: String
    let titleSynonyms: [String]
    let type: String?
    let source: String?
    let episodes: Int?
    let status: String?
    let airing: Bool?
    let aired: Aired?
    let duration: String?
    let rating: String?
    let score: Double?
    let scoredBy: Int?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let synopsis: String?
    let background: String?
    let season: String?
    let year: Int?
    let producers: [Producer]?
    let licensors: [Licensor]?
    let studios: [Studio]?
    let genres: [Genre]?
    let explicitGenres: [ExplicitGenre]?
    let themes: [Theme]?
    let demographics: [Demographic]?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url
        case images
        case trailer
        case approved
        case titles
        case title
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case titleSynonyms = "title_synonyms"
        case type
        case source
        case episodes
        case status
        case airing
        case aired
        case duration
        case rating
        case score
        case scoredBy = "scored_by"
        case rank
        case popularity
        case members
        case favorites
        case synopsis
        case background
        case season
        case year
        case producers
        case licensors
        case studios
        case genres
        case explicitGenres = "explicit_genres"
        case themes
        case demographics
    }
}

struct Images: Codable {
    let jpg: ImageDetails
    let webp: ImageDetails
}

struct ImageDetails: Codable {
    let imageURL: String
    let smallImageURL: String
    let largeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
    }
}

struct Trailer: Codable {
    let youtubeID: String?
    let url: String?
    let embedURL: String?
    let images: TrailerImages?
    
    enum CodingKeys: String, CodingKey {
        case youtubeID = "youtube_id"
        case url
        case embedURL = "embed_url"
        case images
    }
}

struct TrailerImages: Codable {
    let imageURL: String?
    let smallImageURL: String?
    let mediumImageURL: String?
    let largeImageURL: String?
    let maximumImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case mediumImageURL = "medium_image_url"
        case largeImageURL = "large_image_url"
        case maximumImageURL = "maximum_image_url"
    }
}

struct Title: Codable {
    let type: String
    let title: String
}

struct Aired: Codable {
    let from: String?
    let to: String?
    let prop: Prop
    let string: String
}

struct Prop: Codable {
    let from: DateComponents
    let to: DateComponents
}

struct Broadcast: Codable {
    let day: String?
    let time: String?
    let timezone: String?
    let string: String
}

struct Producer: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}

struct Licensor: Codable {
    let malID: Int?
    let type: String?
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}

struct Studio: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}

struct Genre: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}

struct ExplicitGenre: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}

struct Theme: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}

struct Demographic: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type
        case name
        case url
    }
}
