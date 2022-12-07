//
//  ViewModelSearchVc.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 05.11.2022.
//

import Foundation

class ViewModelSeacrVC {
    public var currentPage = 0
    public let totalPages = 5
    public var searched = [Media]()
    public var genres = [Genre]()
    public var popular  = [Media]()
    
    public func searchMovie(query: String, completion: @escaping()->Void) {
        currentPage += 1
        NetworkManager.shared.search(page: currentPage, query: query) { media in
            if self.currentPage == 1 {
                self.searched = media
            } else {
                self.searched += media
            }
            completion()
        }
    }
    
    public func fetchPopularMovies(completion: @escaping()->Void) {
        NetworkManager.shared.loadPopularMovies { media in
            self.popular = media
            completion()
        }
    }
}
