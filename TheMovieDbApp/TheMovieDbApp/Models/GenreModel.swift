//
//  GenreModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import Foundation

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}
