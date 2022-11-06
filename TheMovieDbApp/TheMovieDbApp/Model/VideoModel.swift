//
//  VideoModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 06.11.2022.
//

import Foundation


struct VideoResponce: Codable {
    let id: Int
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case behindTheScenes = "Behind the Scenes"
    case bloopers = "Bloopers"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}
