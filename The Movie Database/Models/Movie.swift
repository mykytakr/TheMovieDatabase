//
//  Movie.swift
//  The Movie Database
//
//  Created by NIKITA on 18.05.2024.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let voteAverage: Double
}
