//
//  PopularViewController.swift
//  The Movie Database
//
//  Created by NIKITA on 18.05.2024.
//

import UIKit
import Alamofire
import SDWebImage

class PopularViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

//    var movies: [Movie] = []
//    var tvShows: [TVShow] = []
//    var timer: Timer?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        fetchPopularMovies()
//    }
//
//    func setupUI() {
//        searchBar.delegate = self
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//
//    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0 {
//            fetchPopularMovies()
//        } else {
//            fetchPopularTVShows()
//        }
//    }
//
//    func fetchPopularMovies() {
//        APIService.shared.fetchPopularMovies { result in
//            switch result {
//            case .success(let movies):
//                self.movies = movies
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }

// func fetchPopularTVShows() {
//        APIService.shared.fetchPopularTVShows { result in
//            switch result {
//            case .success(let tvShows):
//                self.tvShows = tvShows
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//extension PopularViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
//            if self.segmentedControl.selectedSegmentIndex == 0 {
//                self.searchMovies(query: searchText)
//            } else {
//                self.searchTVShows(query: searchText)
//            }
//        }
//    }
//
//    func searchMovies(query: String) {
//        // Implement search logic
//    }
//
//    func searchTVShows(query: String) {
//        // Implement search logic
//    }
//}
//
//extension PopularViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return segmentedControl.selectedSegmentIndex == 0 ? movies.count : tvShows.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // Implement cell configuration
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // Implement navigation to DetailViewController
//    }
}
