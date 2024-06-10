//
//  TrailerModels.swift
//  The Movie Database
//
//  Created by NIKITA on 25.05.2024.
//

import Foundation

struct TrailerResponse: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let key: String
    let site: String
    let type: String
}
