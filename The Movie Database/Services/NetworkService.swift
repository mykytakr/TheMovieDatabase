//
//  NetworkService.swift
//  The Movie Database
//
//  Created by NIKITA on 21.05.2024.
//


import Foundation

class NetworkService {
    static let shared = NetworkService()
    let apiKey = "0f58230b31f300b6f3386f2732a74339"
    let baseURL = "https://api.themoviedb.org/3"
    private var genreMap: [Int: String] = [:]

    private init() {
        fetchGenres()
    }

    // Fetch popular movies with pagination
    func fetchPopularMovies(page: Int = 1, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=\(page)"
        performRequest(with: urlString, completion: completion)
    }

    // Fetch popular series with pagination
    func fetchPopularSeries(page: Int = 1, completion: @escaping ([TVSeries]?) -> Void) {
        let urlString = "\(baseURL)/tv/popular?api_key=\(apiKey)&language=en-US&page=\(page)"
        performRequest(with: urlString, completion: completion)
    }

    // Search movies with pagination
    func searchMovies(query: String, page: Int = 1, completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query)&language=en-US&page=\(page)"
        performRequest(with: urlString, completion: completion)
    }

    // Search series with pagination
    func searchSeries(query: String, page: Int = 1, completion: @escaping ([TVSeries]?) -> Void) {
        let urlString = "\(baseURL)/search/tv?api_key=\(apiKey)&query=\(query)&language=en-US&page=\(page)"
        performRequest(with: urlString, completion: completion)
    }

    // Perform network request
    private func performRequest<T: Codable>(with urlString: String, completion: @escaping ([T]?) -> Void) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data:", error)
                completion(nil)
                return
            }

            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(Response<T>.self, from: data)
                completion(decodedResponse.results)
            } catch {
                print("Failed to decode JSON:", error)
                completion(nil)
            }
        }.resume()
    }

    // Fetch genres for mapping
    private func fetchGenres() {
        let urlString = "\(baseURL)/genre/movie/list?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch genres:", error)
                return
            }

            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(GenreResponse.self, from: data)
                self.genreMap = decodedResponse.genres.reduce(into: [:]) { $0[$1.id] = $1.name }
            } catch {
                print("Failed to decode genres:", error)
            }
        }.resume()
    }

    // Get genres as a comma-separated string
    func getGenres(for ids: [Int]?) -> String {
        guard let ids = ids else { return "Unknown Genre" }
        return ids.compactMap { genreMap[$0] }.joined(separator: ", ")
    }
}

// Codable response structure
struct Response<T: Codable>: Codable {
    let results: [T]
}

// Codable genre response structure
struct GenreResponse: Codable {
    let genres: [Genre]
}

// Codable genre structure
struct Genre: Codable {
    let id: Int
    let name: String
}
