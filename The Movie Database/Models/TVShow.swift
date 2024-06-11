//
//  TVShow.swift
//  The Movie Database
//
//  Created by NIKITA on 18.05.2024.
//

import Foundation

struct TVShow: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let overview: String
    let firstAirDate: String
    let voteAverage: Double
}
