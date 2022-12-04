//
//  ViewModelAllMoviesVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 21.11.2022.
//

import Foundation

class ViewModelAllMoviesVC {
    public var currentPage = 0
    public let totalPages = 3
    public var genres = [Genre]()
    public var arrayOfMediaByGenre = [Media]()

    public func fetchMedia(type: String, genre: Int, completion: @escaping () -> Void) {
        currentPage += 1
        NetworkManager.shared.loadMediaByGenre(type: type, page: currentPage, genre: genre) { media in
            self.arrayOfMediaByGenre += media
            completion()
        }
    }
}
