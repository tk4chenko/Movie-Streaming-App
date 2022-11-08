//
//  ViewModelMoviesVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import Foundation
import Alamofire

class ViewModelMoviesVC {
    
//    var arrayOfMovies = [Title]()
//    var arrayOfTVShows = [Title]()
    
    var arrayOfMovieGenres = [Genre]()
    var arrayOfTVGenres = [Genre]()
    
    var dictOfMovies = [String: [Media]]()
    var dictOfTVShows = [String: [Media]]()

    
    func loadMovieByGenre(completion: @escaping () -> Void) {
        loadGenresforMovies { genres in
            for genre in genres {
                let movieRequest = AF.request("https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&with_genres=\(genre.id)&with_watch_monetization_types=flatrate", method: .get)
                
                movieRequest.responseDecodable(of: MediaResponce.self) { responce in
                    do {
                        let data = try responce.result.get().results
                        self.dictOfMovies[genre.name] = data
                        completion()
                    } catch {
                        print("error: \(error)")
                    }
                    
                }
            }
        }
    }
    
    func loadTvByGenre(completion: @escaping(()->())){
        
        loadGenresforTV { genres in
            
            for genre in genres {
                
                let request = AF.request("https://api.themoviedb.org/3/discover/tv?sort_by=popularity.desc&api_key=\(apiKey)&with_genres=\(genre.id)", method: .get)
                request.responseDecodable(of: MediaResponce.self) { response in
                    do {
                        let data = try response.result.get().results
//                        self.arrayOfTVShows = try response.result.get().results
                        self.dictOfTVShows[genre.name] = data
                        completion()
                    }
                    catch {
                        print("!!!!!!!!!\(error)")
                    }
                    
                }
            }
            
            
        }
    }
    
    func loadGenresforMovies(completion: @escaping ([Genre]) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US", method: .get)
        
        genresRequest.responseDecodable(of: Genres.self) { response in
            do {
                self.arrayOfMovieGenres = try response.result.get().genres
                let data = try response.result.get().genres
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func loadGenresforTV(completion: @escaping ([Genre]) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/genre/tv/list?api_key=\(apiKey)&language=en-US", method: .get)
        
        genresRequest.responseDecodable(of: Genres.self) { response in
            do {
                self.arrayOfTVGenres = try response.result.get().genres
                let data = try response.result.get().genres
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
}
