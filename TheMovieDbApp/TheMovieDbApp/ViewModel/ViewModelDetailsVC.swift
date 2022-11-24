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
    
}
