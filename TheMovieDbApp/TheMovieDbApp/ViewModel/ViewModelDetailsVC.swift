//
//  ViewModelDetailsVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 06.11.2022.
//

import Foundation
import Locksmith

class ViewModelDetailsVC {
    public var arrayOfViedos = [Video]()
    public var watchlist = [Media]()
    public var movieGenres = [Genre]()
    public var tvGenres = [Genre]()
    
    public var movieWatchlist = [Media]()
    public var tvWatchlist = [Media]()
    
    public func fetchMovieGenres(completion: @escaping ([Genre]) -> Void) {
        NetworkManager.shared.loadGenresForMedia(type: "movie") { genres in
            self.movieGenres = genres
            print("MOVIE: \(genres)")
            completion(genres)
        }
    }
    public func fetchTVGenres(completion: @escaping ([Genre]) -> Void) {
        NetworkManager.shared.loadGenresForMedia(type: "tv") { genres in
            self.tvGenres = genres
            print("TV: \(genres)")
            completion(genres)
        }
    }
    
    public func loadTrailers(mediaType: String, movieId: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.loadTrailer(mediaType: mediaType, movieId: movieId) { videos in
            self.arrayOfViedos = videos
            completion()
        }
    }
    public func addToWatchlist(watchlist: Bool, mediaType: String, mediaId: Int, completion: @escaping () -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.addToWatchlist(watchlist: watchlist, accountID: dictionary["account"] as! Int, mediaType: mediaType, mediaId: mediaId, sessionId: dictionary["session"] as! String) { data, mediaType in
            print(data, mediaType)
            completion()
        }
    }
    public func getWatchlist(type: String, completion: @escaping () -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.getWatchlist(type: type, accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.watchlist = media
            completion()
        }
    }
    
    public func getMovieWatchlist(completion: @escaping ([Media]) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.getWatchlist(type: "movies", accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.movieWatchlist = media
            completion(media)
        }
    }
    
    public func getTVWatchlist(completion: @escaping ([Media]) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "Session") else { return }
        NetworkManager.shared.getWatchlist(type: "tv", accountId: dictionary["account"] as! Int, sessionId: dictionary["session"] as! String) { media in
            self.tvWatchlist = media
            completion(media)
        }
    }
}
