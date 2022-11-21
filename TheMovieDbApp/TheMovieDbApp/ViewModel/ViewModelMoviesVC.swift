//
//  ViewModelMoviesVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import Foundation

var sessionId = String()
var accountId = Int()

class ViewModelMoviesVC {
    
    public var arrayOfMediaByGenre = [Media]()
    public var upcoming = [Media]()
    public var trending = [Media]()
    public var topRated = [Media]()
    public var genres = [Genre]()
    
    func fetchGenres(type: String, completion: @escaping () -> Void) {
        NetworkManager.shared.loadGenresForMedia(type: type) { genres in
            self.genres = genres
            completion()
        }
    }
    
    func delSession() {
        NetworkManager.shared.deleteSession(sessionId: sessionId)
    }
    
    func fetchTrending(type: String, completion: @escaping () -> Void) {
        NetworkManager.shared.loadTrending(type: type) { media in
            self.trending = media
            completion()
        }
    }
    
    func fetchUpcoming(type: String, completion: @escaping () -> Void) {
        NetworkManager.shared.loadUpcoming(type: type) { media in
            self.upcoming = media
            completion()
        }
    }
    
    func fetchTopRated(type: String, completion: @escaping () -> Void) {
        NetworkManager.shared.loadTopRated(type: type) { media in
            self.topRated = media
            completion()
        }
    }
    
}
