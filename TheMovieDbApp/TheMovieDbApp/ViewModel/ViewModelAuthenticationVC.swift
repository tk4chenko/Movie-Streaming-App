//
//  ViewModelAuthenticationVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 01.11.2022.
//

import Foundation
import Alamofire

let apiKey = "e1988c5fd4dfd50566522f6ff287a95b"

class ViewModelAuthenticationVC {
    
    func createRequestToken(completion: @escaping (String) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)", method: .get)
        
        genresRequest.responseDecodable(of: TokenResponce.self) { response in
            do {
                let data = try response.result.get().requestToken
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func createSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping (TokenResponce) -> Void) {
        
        let parameters: [String: Any] = [
              "username": username,
              "password": password,
              "request_token": requestToken
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: TokenResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func createSession(requestToken: String, completion: @escaping (TokenResponce) -> Void) {
        
        let parameters: [String: Any] = [
          "request_token": requestToken
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: TokenResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
}
