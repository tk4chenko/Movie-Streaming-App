//
//  ViewModelWatchlistVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 07.11.2022.
//

import Foundation

class ViewModelWatchlistVC {
    
    public var arrayOfMoviesWatchlist = [Media]()
    public var arrayOfTVShowsWatchlist = [Media]()
    
    public func fetchMovieWatchlist(completion: @escaping() -> Void) {
        NetworkManager.shared.getMovieWatchlist(accountId: accountId, sessionId: sessionId) { media in
            self.arrayOfMoviesWatchlist = media.reversed()
            completion()
        }
    }
    
    public func fetchTVShowsWatchlist(completion: @escaping() -> Void) {
        NetworkManager.shared.getTVShowsWatchlist(accountId: accountId, sessionId: sessionId) { media in
            self.arrayOfTVShowsWatchlist = media.reversed()
            completion()
        }
    }
    
    public func remove(mediaType: String, mediaId: Int, completion: @escaping() -> Void) {
        NetworkManager.shared.removeFromWatchlist(accountID: accountId, mediaType: mediaType, mediaId: mediaId, sessionId: sessionId) { session, mediaId in
            print(session, mediaId)
            completion()
        }
    }
    
}
