//
//  ViewModelSearchVc.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 05.11.2022.
//

import Foundation
import Alamofire

class ViewModelSeacrVC {
    
    var currentPage = 1
    let totalPages = 5
    
    let apiKey = "e1988c5fd4dfd50566522f6ff287a95b"
    
    func search(page: Int, query: String, completion: @escaping([Media])->Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let movieRequest = AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&page=\(page)&query=\(query)", method: .get)
        movieRequest.responseDecodable(of: MediaResponce.self) { responce in
            do {
                let data = try responce.result.get().results
                completion(data)
            } catch {
//                completion(.failure(error))
            }
            
        }
        
    }
    
    func loadGenresforMovies(completion: @escaping ([Genre]) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US", method: .get)
        
        genresRequest.responseDecodable(of: Genres.self) { response in
            do {
//                self.arrayOfMovieGenres = try response.result.get().genres
                let data = try response.result.get().genres
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
}
