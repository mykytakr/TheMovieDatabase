//
//  PopularMoviesViewController.swift
//  The Movie Database
//
//  Created by NIKITA on 21.05.2024.
//


import UIKit
import WebKit

class PopularViewController: UIViewController, WKNavigationDelegate {
    private let mainView = PopularView()
    private var movies: [Movie] = []
    private var series: [TVSeries] = []
    
    private var isShowingMovies = true
    private var currentPage = 1
    private var isLoading = false

    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchPopularMovies()
    }
}

//MARK: -  Actions
extension PopularViewController {
    @objc private func segmentChanged() {
        isShowingMovies = mainView.segmentedControl.selectedSegmentIndex == 0
        currentPage = 1
        movies.removeAll()
        series.removeAll()
        mainView.tableView.reloadData()
        if isShowingMovies {
            fetchPopularMovies()
        } else {
            fetchPopularSeries()
        }
    }
}

//MARK: - Private Methods
extension PopularViewController {
    private func fetchPopularMovies(page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        NetworkService.shared.fetchPopularMovies(page: page) { [weak self] (movies: [Movie]?) in
            guard let self = self else { return }
            self.isLoading = false
            guard let movies = movies else { return }
            self.movies.append(contentsOf: movies)
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    private func fetchPopularSeries(page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        NetworkService.shared.fetchPopularSeries(page: page) { [weak self] (series: [TVSeries]?) in
            guard let self = self else { return }
            self.isLoading = false
            guard let series = series else { return }
            self.series.append(contentsOf: series)
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        title = "Popular"
        view.backgroundColor = .black
        mainView.searchController.searchResultsUpdater = self
        navigationItem.searchController = mainView.searchController
        definesPresentationContext = true
        
        // Setup segmented control
        mainView.segmentedControl.selectedSegmentIndex = 0
        mainView.segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        mainView.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        mainView.tableView.register(SeriesCell.self, forCellReuseIdentifier: "SeriesCell")
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension PopularViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingMovies ? movies.count : series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowingMovies {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = movies[indexPath.row]
            cell.configure(with: movie)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as! SeriesCell
            if indexPath.row < series.count {
                let seriesItem = series[indexPath.row]
                cell.configure(with: seriesItem)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowingMovies {
            let movie = movies[indexPath.row]
            let detailVC = MovieDetailController()
            detailVC.movie = movie
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let series = series[indexPath.row]
            let detailVC = SeriesDetailController()
            detailVC.series = series
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

//MARK: - Pagination upon reaching the end of the list
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            currentPage += 1
            if isShowingMovies {
                fetchPopularMovies(page: currentPage)
            } else {
                fetchPopularSeries(page: currentPage)
            }
        }
    }
}

//MARK: - UISearchResultsUpdating
extension PopularViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            currentPage = 1
            if isShowingMovies {
                fetchPopularMovies(page: currentPage)
            } else {
                fetchPopularSeries(page: currentPage)
            }
            return
        }
        currentPage = 1
        if isShowingMovies {
            searchMovies(query: query, page: currentPage)
        } else {
            searchSeries(query: query, page: currentPage)
        }
    }
    
    private func searchMovies(query: String, page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        NetworkService.shared.searchMovies(query: query, page: page) { [weak self] (movies: [Movie]?) in
            guard let self = self else { return }
            self.isLoading = false
            if page == 1 {
                self.movies.removeAll()
            }
            self.movies.append(contentsOf: movies ?? [])
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    private func searchSeries(query: String, page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        NetworkService.shared.searchSeries(query: query, page: page) { [weak self] (series: [TVSeries]?) in
            guard let self = self else { return }
            self.isLoading = false
            if page == 1 {
                self.series.removeAll()
            }
            self.series.append(contentsOf: series ?? [])
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
}
