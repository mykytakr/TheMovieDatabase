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
    let genreIds: [Int]
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "first_air_date"
        case voteAverage = "vote_average"
    }
}





