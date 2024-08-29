//
//  LNEndpoint.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import Foundation

@frozen enum LNEndpoint: String{
    /// endpoint to get latest anime
    case latestAnime = "seasons/now"
    case winter2024 = "seasons/2024/winter"
    case upcoming = "seasons/upcoming"
    case searchAnime = "anime" 
}
