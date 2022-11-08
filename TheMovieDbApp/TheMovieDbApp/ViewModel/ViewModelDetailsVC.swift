//
//  ViewModelDetailsVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 06.11.2022.
//

import Foundation
import Alamofire

enum MediaType: String{
    case movie
    case tv
}

class ViewModelDetailsVC {
    
    var arrayOfViedos = [Video]()
    
    func loadTrailer(mediaType: MediaType, movieId: Int, completion: @escaping ([Video]) -> ()) {
        
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
    
    func addToWatchlist(mediaType: MediaType, mediaId: Int, sessionId: String, completion: @escaping () -> Void) {
        
        let parameters: [String: Any] = [
              "media_type": mediaType,
              "media_id": mediaId,
              "watchlist": true
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account/14577701/watchlist?api_key=\(apiKey)&session_id=\(sessionId)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                _ = try response.result.get()
                completion()
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    
}
