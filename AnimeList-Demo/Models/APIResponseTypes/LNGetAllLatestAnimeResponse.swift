//
//  LNGetAllLatestAnimeResponse.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import Foundation

struct LNGetAllLatestAnimeResponse: Codable {
    let data: [Anime]
}

struct LNGetAllUpcomingAnimeResponse: Codable {
    let data: [Anime]
}

