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
    
    //    let mediaType = MediaType.movie
    
    func loadTrailerForMovie(mediaType: MediaType, movieId: Int, completion: @escaping ([Video]) -> ()) {
        
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
}
