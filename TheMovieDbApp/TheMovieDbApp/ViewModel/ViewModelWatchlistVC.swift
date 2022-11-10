//
//  ViewModelWatchlistVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 07.11.2022.
//

import Foundation
import Alamofire

class ViewModelWatchlistVC {
    
    var arrayOfMoviesWatchlist = [Media]()
    var arrayOfTVShowsWatchlist = [Media]()
    
    func getMovieWatchlist(accountId: Int, sessionId: String, completion: @escaping([Media]) -> ()) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account/\(accountId)/watchlist/movies?language=en-US&sort_by=created_at.asc&page=1&api_key=e1988c5fd4dfd50566522f6ff287a95b&session_id=\(sessionId)", method: .get)
        
        genresRequest.responseDecodable(of: MediaResponce.self) { response in
            do {
                //                self.arrayOfMoviesWatchlist = try response.result.get().results
                let data = try response.result.get().results
//                self.arrayOfMoviesWatchlist = data.reversed()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
        
        func getTVShowsWatchlist(accountId: Int, sessionId: String, completion: @escaping(([Media])->())) {
            
            let genresRequest = AF.request("https://api.themoviedb.org/3/account/\(accountId)/watchlist/tv?language=en-US&sort_by=created_at.asc&page=1&api_key=e1988c5fd4dfd50566522f6ff287a95b&session_id=\(sessionId)", method: .get)
            
            genresRequest.responseDecodable(of: MediaResponce.self) { response in
                do {
                    //                self.arrayOfMoviesWatchlist = try response.result.get().results
                    let data = try response.result.get().results
                    self.arrayOfTVShowsWatchlist = data.reversed()
                    completion(data)
                }
                catch {
                    print("error: \(error)")
                }
                
            }
        }
    
    func removeFromWatchlist(accountID: Int, mediaType: String, mediaId: Int, sessionId: String, completion: @escaping (Welcome, Int) -> Void) {
        
        let parameters: [String: Any] = [
            "media_type": mediaType,
            "media_id": mediaId,
            "watchlist": false
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account/\(accountID)/watchlist?api_key=\(apiKey)&session_id=\(sessionId)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: Welcome.self) { response in
            do {
                let data = try response.result.get()
                completion(data, mediaId)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
        
}
