//
//  MovieModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import Foundation

struct MovieResponce: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int

//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
}

struct Movie: Codable {
    let adult: Bool
    let backdrop_path: String
    let id: Int
    let title: String
    let original_language: String
    let original_title: String
    let overview: String
    let poster_path: String?
    let media_type: MediaType
    let genre_ids: [Int]
    let popularity: Double
    let release_date: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int

//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case id, title
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview
//        case posterPath = "poster_path"
//        case mediaType = "media_type"
//        case genreIDS = "genre_ids"
//        case popularity
//        case releaseDate = "release_date"
//        case video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
}

enum MediaType: String, Codable {
    case movie = "movie"
}

//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case fr = "fr"
//    case ja = "ja"
//}
