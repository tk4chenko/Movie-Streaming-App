//
//  ViewModelAuthenticationVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 01.11.2022.
//

import Foundation
import Locksmith

class ViewModelAuthenticationVC {
    
    public func createSession(username: String, password: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.createRequestToken { token in
            do {
                try Locksmith.updateData(data: ["username": username, "password": password], forUserAccount: "MyAccount")
            } catch {
                print(error)
            }
            guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount") else { return }
            NetworkManager.shared.createSessionWithLogin(username: dictionary["username"] as! String, password: dictionary["password"] as! String, requestToken: token) {
                NetworkManager.shared.createSession(requestToken: token) { session in
                    NetworkManager.shared.getAccountId(sessionId: session.session_id ?? "") { account in
                        do {
                            try Locksmith.updateData(data: ["session" : session.session_id ?? "", "account": account.id ?? 0], forUserAccount: "Session")
                        } catch {
                            
                        }
                    }
                    completion(session.success )
                }
            }
        }
    }
    public func createGuestSession(completion: @escaping (SessionResponce) -> Void) {
        NetworkManager.shared.createGuestSession { responce in
            do {
                try Locksmith.updateData(data: ["session" : responce.guest_session_id ?? "", "account": 0], forUserAccount: "Session")
            } catch {
               print(error)
            }
            print(responce.guest_session_id ?? "hernya")
            completion(responce)
        }
    }
}
