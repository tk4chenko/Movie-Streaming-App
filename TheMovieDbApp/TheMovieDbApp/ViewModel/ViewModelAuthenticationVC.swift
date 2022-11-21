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
    
    func getRequestToken(completion: @escaping (String) -> Void) {
        NetworkManager.shared.createRequestToken { token in
            completion(token)
        }
    }
    
    func createSessionUsingLogin(username: String, password: String, requestToken: String) {
        NetworkManager.shared.createSessionWithLogin(username: username, password: password, requestToken: requestToken)
    }
    
    func createSess(requestToken: String) {
        NetworkManager.shared.createSession(requestToken: requestToken) { responce in
            sessionId = responce.session_id ?? ""
        }
    }
    
    func getAccId(sessionId: String) {
        NetworkManager.shared.getAccountId(sessionId: sessionId) { responce in
            accountId = responce.id ?? 0
        }
    }
    
    func createGuestSess(completion: @escaping (SessionResponce) -> Void) {
        NetworkManager.shared.createGuestSession { responce in
            sessionId = responce.session_id ?? ""
            completion(responce)
        }
    }
    
    
    func createRequestToken(completion: @escaping (String) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)", method: .get)
         
        genresRequest.responseDecodable(of: TokenResponce.self) { response in
            do {
                let data = try response.result.get().request_token
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func createSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping () -> Void) {
        
        let parameters: [String: Any] = [
              "username": username,
              "password": password,
              "request_token": requestToken
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
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
    
    func createSession(requestToken: String, completion: @escaping (SessionResponce) -> Void) {
        
        let parameters: [String: Any] = [
          "request_token": requestToken
        ]
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    }
    
    func getAccountId(sessionId: String, completion: @escaping (AccountID) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionId)", method: .get)
        
        genresRequest.responseDecodable(of: AccountID.self) { response in
            do {
                let data = try response.result.get()
                completion(data)
            }
            catch {
                print("error: \(error)")
            }
            
        }
    
    }
    
    func createGuestSession(completion: @escaping (SessionResponce) -> Void) {
        
        let genresRequest = AF.request("https://api.themoviedb.org/3/authentication/guest_session/new?api_key=\(apiKey)", method: .get)
        
        genresRequest.responseDecodable(of: SessionResponce.self) { response in
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
