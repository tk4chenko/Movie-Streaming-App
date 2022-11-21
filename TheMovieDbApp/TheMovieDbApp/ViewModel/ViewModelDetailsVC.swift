//
//  ViewModelDetailsVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 06.11.2022.
//

import Foundation
import Alamofire

class ViewModelDetailsVC {
    
    var arrayOfViedos = [Video]()
    
    func loadTrailer(mediaType: String, movieId: Int, completion: @escaping ([Video]) -> ()) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/\(mediaType)/\(movieId)/videos?api_key=\(apiKey)", method: .get)
        
        genresRequest.responseDecodable(of: VideoResponce.self) { response in
            do {
                self.arrayOfViedos = try response.result.get().results
                let filtered = self.arrayOfViedos.filter { video in
                    return video.type.rawValue == "Trailer"
                }
                completion(filtered)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    
    }
    
    func addToWatchlist(watchlist: Bool, accountID: Int, mediaType: String, mediaId: Int, sessionId: String, completion: @escaping (Welcome, String) -> Void) {
        
        let parameters: [String: Any] = [
              "media_type": mediaType,
              "media_id": mediaId,
              "watchlist": watchlist
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account/\(accountID)/watchlist?api_key=\(apiKey)&session_id=\(sessionId)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: Welcome.self) { response in
            do {
                let data = try response.result.get()
                completion(data, mediaType)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func getWatchlist(type: String, accountId: Int, sessionId: String, completion: @escaping(([Media])->())) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account/\(accountId)/watchlist/\(type)?language=en-US&sort_by=created_at.asc&page=1&api_key=e1988c5fd4dfd50566522f6ff287a95b&session_id=\(sessionId)", method: .get)
        
        genresRequest.responseDecodable(of: MediaResponce.self) { response in
            do {
//                self.arrayOfMoviesWatchlist = try response.result.get().results
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    
}
