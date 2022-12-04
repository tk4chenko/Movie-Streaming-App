//
//  ViewModelWatchlistVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 07.11.2022.
//

import Foundation
import Locksmith

class ViewModelWatchlistVC {
    public var arrayOfMoviesWatchlist = [Media]()
    public var arrayOfTVShowsWatchlist = [Media]()
    public var movieGenres = [Genre]()
    public var tvGenres = [Genre]()
    
    public func fetchMovieWatchlist(completion: @escaping() -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.getMovieWatchlist(accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.arrayOfMoviesWatchlist = media.reversed()
            completion()
        }
    }
    public func fetchTVShowsWatchlist(completion: @escaping() -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.getTVShowsWatchlist(accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.arrayOfTVShowsWatchlist = media.reversed()
            completion()
        }
    }
    public func remove(mediaType: String, mediaId: Int, completion: @escaping() -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.removeFromWatchlist(accountID: dictionary["account"] as! Int, mediaType: mediaType, mediaId: mediaId, sessionId: dictionary["session"] as! String) { session, mediaId in
            print(session, mediaId)
            completion()
        }
    }
    public func fetchMovieGenres() {
        NetworkManager.shared.loadGenresForMedia(type: "movie") { genres in
            self.movieGenres = genres
        }
    }
    public func fetchTVGenres() {
        NetworkManager.shared.loadGenresForMedia(type: "tv") { genres in
            self.tvGenres = genres
        }
    }
}
