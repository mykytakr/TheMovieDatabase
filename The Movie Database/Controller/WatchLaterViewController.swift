//
//  WatchLaterViewController.swift
//  The Movie Database
//
//  Created by NIKITA on 21.05.2024.
//

import UIKit

class WatchLaterViewController: UIViewController {
    private var watchLaterMovies: [Movie] = []
    private var watchLaterSeries: [TVSeries] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchWatchLaterItems()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchWatchLaterItems), name: NSNotification.Name("WatchLaterUpdated"), object: nil)
    }
    
    private func setupUI() {
        title = "Watch Later"
        
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.register(SeriesCell.self, forCellReuseIdentifier: "SeriesCell")
    }
    
    @objc private func fetchWatchLaterItems() {
        watchLaterMovies = WatchLaterManager.shared.getWatchLaterMovies()
        watchLaterSeries = WatchLaterManager.shared.getWatchLaterSeries()
        tableView.reloadData()
    }
    
    private func removeItemFromWatchLater(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            let movie = watchLaterMovies[indexPath.row]
            WatchLaterManager.shared.removeMovieFromWatchLater(movie)
            watchLaterMovies = WatchLaterManager.shared.getWatchLaterMovies()
        } else {
            let series = watchLaterSeries[indexPath.row]
            WatchLaterManager.shared.removeSeriesFromWatchLater(series)
            watchLaterSeries = WatchLaterManager.shared.getWatchLaterSeries()
        }
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
}

extension WatchLaterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? watchLaterMovies.count : watchLaterSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = watchLaterMovies[indexPath.row]
            cell.configure(with: movie, showWatchLaterButton: false)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as! SeriesCell
            let series = watchLaterSeries[indexPath.row]
            cell.configure(with: series, showWatchLaterButton: false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let movie = watchLaterMovies[indexPath.row]
            let detailVC = MovieDetailController()
            detailVC.movie = movie
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let series = watchLaterSeries[indexPath.row]
            let detailVC = SeriesDetailController()
            detailVC.series = series
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    // Adding the swipe to delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItemFromWatchLater(at: indexPath)
        }
    }
}
