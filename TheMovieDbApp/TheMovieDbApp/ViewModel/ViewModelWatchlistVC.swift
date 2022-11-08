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
    
    func getWatchlist(accountId: Int, sessionId: String, completion: @escaping(([Media])->())) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account/\(accountId)/watchlist/movies?language=en-US&sort_by=created_at.asc&page=1&api_key=e1988c5fd4dfd50566522f6ff287a95b&session_id=\(sessionId)", method: .get)
        
        genresRequest.responseDecodable(of: MediaResponce.self) { response in
            do {
                self.arrayOfMoviesWatchlist = try response.result.get().results
                let data = try response.result.get().results
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }    
    
}
