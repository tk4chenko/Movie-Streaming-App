//
//  ViewModelMoviesVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import Foundation
import Alamofire

class ViewModelMoviesVC {
    
    var arrayOfMovies = [Movie]()
    var arrayOfMovieGenres = [Genre]()
    
    
    func loadTrendingMovies(completion: @escaping () -> Void) {
        
        let movieRequest = AF.request("https://api.themoviedb.org/3/trending/movie/week?api_key=\(apiKey)", method: .get)
        
        movieRequest.responseDecodable(of: MovieResponce.self) { responce in
            do {
                self.arrayOfMovies = try responce.result.get().results
                //                let data = try responce.result.get().results
                //                completion(data)
            } catch {
                print("error: \(error)")
            }
            completion()
            
        }
    }
    
    func loadGenresforMovies(completion: @escaping () -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US", method: .get)
        
        genresRequest.responseDecodable(of: Genres.self) { response in
            do {
                self.arrayOfMovieGenres = try response.result.get().genres
//                let data = try response.result.get().genres
//                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
}
