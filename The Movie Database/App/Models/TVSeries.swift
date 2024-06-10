//
//  Series.swift
//  The Movie Database
//
//  Created by NIKITA on 23.05.2024.
//

import Foundation

struct TVSeries: Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let genre: String
    let releaseYear: Int
    let rating: Double
    let director: String

    enum CodingKeys: String, CodingKey {
        case id, name, overview, genre, releaseYear = "release_year", rating, director
        case posterPath = "poster_path"
    }
}
