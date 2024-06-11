//
//  WatchLaterManager.swift
//  The Movie Database
//
//  Created by NIKITA on 22.05.2024.
//


import Foundation

final class WatchLaterManager {
    static let shared = WatchLaterManager()
    
    private let watchLaterMoviesKey = "WatchLaterMovies"
    private let watchLaterSeriesKey = "WatchLaterSeries"

    private init() {}

    // MARK: - Movies

    func addMovieToWatchLater(_ movie: Movie, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var watchLaterMovies = getWatchLaterMovies()
        guard !watchLaterMovies.contains(where: { $0.id == movie.id }) else {
            failure()  // Failure callback
            return
        }
        watchLaterMovies.append(movie)
        saveWatchLaterMovies(watchLaterMovies)
        success()  // Success callback
    }

    func removeMovieFromWatchLater(_ movie: Movie) {
        var watchLaterMovies = getWatchLaterMovies()
        watchLaterMovies.removeAll { $0.id == movie.id }
        saveWatchLaterMovies(watchLaterMovies)
    }

    func isMovieInWatchLater(_ movie: Movie) -> Bool {
        return getWatchLaterMovies().contains { $0.id == movie.id }
    }

    func getWatchLaterMovies() -> [Movie] {
        return loadWatchLaterItems(forKey: watchLaterMoviesKey)
    }

    // MARK: - Series

    func addSeriesToWatchLater(_ series: TVSeries, success: @escaping () -> Void, failure: @escaping () -> Void) {
        var watchLaterSeries = getWatchLaterSeries()
        guard !watchLaterSeries.contains(where: { $0.id == series.id }) else {
            failure()  // Failure callback
            return
        }
        watchLaterSeries.append(series)
        saveWatchLaterSeries(watchLaterSeries)
        success()  // Success callback
    }

    func removeSeriesFromWatchLater(_ series: TVSeries) {
        var watchLaterSeries = getWatchLaterSeries()
        watchLaterSeries.removeAll { $0.id == series.id }
        saveWatchLaterSeries(watchLaterSeries)
    }

    func isSeriesInWatchLater(_ series: TVSeries) -> Bool {
        return getWatchLaterSeries().contains { $0.id == series.id }
    }

    func getWatchLaterSeries() -> [TVSeries] {
        return loadWatchLaterItems(forKey: watchLaterSeriesKey)
    }

    // MARK: - Private Methods

    private func loadWatchLaterItems<T: Codable>(forKey key: String) -> [T] {
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decodedItems = try? JSONDecoder().decode([T].self, from: savedData) {
            return decodedItems
        }
        return []
    }

    private func saveWatchLaterItems<T: Codable>(_ items: [T], forKey key: String) {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: key)
            NotificationCenter.default.post(name: NSNotification.Name("WatchLaterUpdated"), object: nil)
        }
    }

    private func saveWatchLaterMovies(_ movies: [Movie]) {
        saveWatchLaterItems(movies, forKey: watchLaterMoviesKey)
    }

    private func saveWatchLaterSeries(_ series: [TVSeries]) {
        saveWatchLaterItems(series, forKey: watchLaterSeriesKey)
    }
}
