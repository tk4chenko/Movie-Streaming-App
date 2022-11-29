//
//  ViewModelSearchVc.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 05.11.2022.
//

import Foundation

class ViewModelSeacrVC {
    public var currentPage = 0
    public let totalPages = 5
    public var searched = [Media]()
    public var genres = [Genre]()
    
    public func searchMovie(query: String, completion: @escaping()->Void) {
        currentPage += 1
        NetworkManager.shared.search(page: currentPage, query: query) { media in
            if self.currentPage == 1 {
                self.searched = media
            } else {
                self.searched += media
            }
            completion()
        }
    }
    
    public func loadGenres() {
        NetworkManager.shared.loadGenresforMovies { genres in
            self.genres = genres
        }
    }
    
//    func search(page: Int, query: String, completion: @escaping([Media])->Void) {
//
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//
//        let movieRequest = AF.request("https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&page=\(page)&query=\(query)", method: .get)
//        movieRequest.responseDecodable(of: MediaResponce.self) { responce in
//            do {
//                let data = try responce.result.get().results
//                completion(data)
//            } catch {
////                completion(.failure(error))
//            }
//
//        }
//
//    }
    
//    func loadGenresforMovies(completion: @escaping ([Genre]) -> Void) {
//
//        let genresRequest = AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US", method: .get)
//
//        genresRequest.responseDecodable(of: Genres.self) { response in
//            do {
////                self.arrayOfMovieGenres = try response.result.get().genres
//                let data = try response.result.get().genres
//                completion(data)
//            }
//            catch {
//                print("error: \(error)")
//            }
//
//        }
//    }
}
