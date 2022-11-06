//
//  MovieModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import Foundation

struct MediaResponce: Codable {
    let page: Int
    let results: [Media]
    let total_pages: Int
    let total_results: Int
}

struct Media: Codable {
    let backdrop_path: String?
    let id: Int
    let name: String?
    let title: String?
    let original_name: String?
    let original_language: String
    let original_title: String?
    let overview: String
    let poster_path: String?
    let genre_ids: [Int]
    let popularity: Double
    let first_air_date: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
}
