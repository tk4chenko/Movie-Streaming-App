//
//  AuthenticationModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 01.11.2022.
//

import Foundation

struct TokenResponce: Codable {
    let success: Bool
    let expires_at, request_token: String
}

struct SessionResponce: Codable {
    let success: Bool
    let failure: Bool?
    let status_code: Int?
    let status_message: String?
    let session_id: String?
}
