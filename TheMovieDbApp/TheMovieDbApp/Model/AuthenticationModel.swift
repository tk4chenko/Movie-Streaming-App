//
//  AuthenticationModel.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 01.11.2022.
//

import Foundation

struct TokenResponce: Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
}

struct SessionResponce: Codable {
    let success: Bool
    let failure: Bool?
    let status_code: Int?
    let status_message: String?
    let session_id: String?
    let guestSessionID: String?
}

struct AccountID: Codable {
    let id: Int?
    let iso639_1: String?
    let so3166_1: String?
    let name: String?
    let include_adult: Bool?
    let username: String
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
}

struct Welcome: Codable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
