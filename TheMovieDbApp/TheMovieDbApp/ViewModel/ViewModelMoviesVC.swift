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
    
    var dictOfMovies = [String: [Media]]()
    var dictOfTVShows = [String: [Media]]()
    var arrayOfMovieGenres = [Genre]()
    var arrayOfTVGenres = [Genre]()
    
    
    var arrayOfMediaByGenre = [Media]()
    var upcoming = [Media]()
    var trending = [Media]()
    var topRated = [Media]()
    var genres = [Genre]()
    
    func fetchGenres(type: String, completion: @escaping () -> Void) {
        NetworkManager.shared.loadGenresForMedia(type: type) { genres in
            self.genres = genres
            completion()
        }
    }
    
    func fetchMedia(type: String, page: Int, genre: Int, completion: @escaping () -> Void) {
        NetworkManager.shared.loadMediaByGenre(type: type, page: page, genre: genre) { media in
            self.arrayOfMediaByGenre = media
            completion()
        }
        
    }
    
    func delSession(sessionId: String, completion: @escaping () -> Void) {
        NetworkManager.shared.deleteSession(sessionId: sessionId)
        completion()
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
    
    func loadGenresForMedia(type: String, completion: @escaping () -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/genre/\(type)/list?api_key=\(apiKey)&language=en-US", method: .get)
        
        genresRequest.responseDecodable(of: Genres.self) { response in
            do {
                self.genres = try response.result.get().genres
//                let data = try response.result.get().genres
                completion()
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func loadMediaByGenre(type: String, page: Int, genre: Int, completion: @escaping ([Media]) -> Void) {
        let movieRequest = AF.request("https://api.themoviedb.org/3/discover/\(type)?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&page=\(page)&include_video=false&with_genres=\(genre)&with_watch_monetization_types=flatrate", method: .get)
        
        movieRequest.responseDecodable(of: MediaResponce.self) { responce in
            do {
                let data = try responce.result.get().results
                completion(data)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
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
    
    func deleteSession(sessionId: String) {
        let parameters: [String: Any] = [
            "session_id": sessionId
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/session?api_key=\(apiKey)", method: .delete, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                print(data.success)
            }
            catch {
                print("error: \(error)")
            }
            
        }
        
    }
    
    func loadTrending(type: String, completion: @escaping() -> Void) {
        
        let movieRequest = AF.request("https://api.themoviedb.org/3/trending/\(type)/day?api_key=\(apiKey)", method: .get)
        
        movieRequest.responseDecodable(of: MediaResponce.self) { response in
            do {
                self.trending = try response.result.get().results
//                let data = try response.result.get().results
                completion()
            }
            catch {
                print("error: \(error)")
            }
            
        }
        
    }
    
    func loadUpcoming(type: String, completion: @escaping() -> Void) {
        let movieRequest = AF.request("https://api.themoviedb.org/3/\(type)/popular?api_key=\(apiKey)&language=en-US", method: .get)
        
        movieRequest.responseDecodable(of: MediaResponce.self) { response in
            do {
                self.upcoming = try response.result.get().results
                //                let data = try response.result.get().results
                completion()
            }
            catch {
                print("error: \(error)")
            }
            
        }
        
    }
    
    func loadTopRated(type: String, completion: @escaping() -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/\(type)/top_rated?api_key=\(apiKey)&language=en-US&page=1", method: .get)
        
        genresRequest.responseDecodable(of: MediaResponce.self) { response in
            do {
                //                self.arrayOfMoviesWatchlist = try response.result.get().results
                self.topRated = try response.result.get().results
                completion()
            }
            catch {
                print("error: \(error)")
            }
            
        }
        
    }
    
}
