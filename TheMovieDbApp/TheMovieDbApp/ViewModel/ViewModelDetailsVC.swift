//
//  ViewModelDetailsVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 06.11.2022.
//

import Foundation

class ViewModelDetailsVC {
    public var arrayOfViedos = [Video]()
    public var watchlist = [Media]()
    
    public func loadTrailers(mediaType: String, movieId: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.loadTrailer(mediaType: mediaType, movieId: movieId) { videos in
            self.arrayOfViedos = videos
            completion()
        }
    }
    
    public func addToWatchlist(watchlist: Bool, mediaType: String, mediaId: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.addToWatchlist(watchlist: watchlist, accountID: accountId, mediaType: mediaType, mediaId: mediaId, sessionId: sessionId) { data, mediaType in
            print(data, mediaType)
            completion()
        }
    }
    
    public func getWatchlist(type: String, completion: @escaping () -> Void) {
        NetworkManager.shared.getWatchlist(type: type, accountId: accountId, sessionId: sessionId) { media in
            self.watchlist = media
            completion()
        }
    }
    
}
