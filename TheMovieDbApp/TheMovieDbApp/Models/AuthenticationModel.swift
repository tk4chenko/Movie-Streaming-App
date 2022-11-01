//
//  AuthenticationModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 01.11.2022.
//

import Foundation

struct TokenResponce: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct Validate: Codable {
    let username, password, requestToken: String

    enum CodingKeys: String, CodingKey {
        case username, password
        case requestToken = "request_token"
    }
}
