//
//  ViewModelAuthenticationVC.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 01.11.2022.
//

import Foundation
import Alamofire

class ViewModelAuthenticationVC {
    public func createSession(username: String, password: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.createRequestToken { token in
            NetworkManager.shared.createSessionWithLogin(username: username, password: password, requestToken: token) {
                NetworkManager.shared.createSession(requestToken: token) { session in
                    sessionId = session.session_id ?? ""
                    NetworkManager.shared.getAccountId(sessionId: session.session_id ?? "") { responce in
                        accountId = responce.id ?? 0
                    }
                    completion(session.success )
                }
            }
        }
    }
    public func createGuestSession(completion: @escaping (SessionResponce) -> Void) {
        NetworkManager.shared.createGuestSession { responce in
            sessionId = responce.session_id ?? ""
            completion(responce)
        }
    }
}
