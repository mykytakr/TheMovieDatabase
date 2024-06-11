//
//  APIService.swift
//  The Movie Database
//
//  Created by NIKITA on 18.05.2024.
//

//import Foundation
//
//class APIService {
//    static let shared = APIService()
//    private let baseURL = "https://api.themoviedb.org/3"
//    private let apiKey = "YOUR_API_KEY"
//
//    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
//        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else { return }
//            do {
//                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
//                completion(.success(response.results))
//            } catch let jsonError
