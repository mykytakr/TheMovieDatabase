//
//  Movie.swift
//  The Movie Database
//
//  Created by NIKITA on 21.05.2024.
//


import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let genreIds: [Int]
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
