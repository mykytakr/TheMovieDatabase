//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by NIKITA on 21.05.2024.
//


import UIKit
import youtube_ios_player_helper

class MovieDetailController: UIViewController {
    var movie: Movie?
    
    private let tableView = UITableView()
    private var trailerID: String?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let playerView = YTPlayerView()
    private let noTrailerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayMovieDetails()
        fetchTrailer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupUI() {
        title = "Movie Details"
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(playerView)
        contentView.addSubview(noTrailerLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        playerView.translatesAutoresizingMaskIntoConstraints = false
        noTrailerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            genreLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            yearLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 16),
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 16),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            playerView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            
            noTrailerLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            noTrailerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noTrailerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noTrailerLabel.heightAnchor.constraint(equalToConstant: 200),
            noTrailerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = .lightGray
        
        genreLabel.numberOfLines = 2
        genreLabel.textColor = .gray
        
        yearLabel.numberOfLines = 1
        yearLabel.textColor = .gray
        
        ratingLabel.numberOfLines = 1
        ratingLabel.textColor = .gray
        
        noTrailerLabel.text = "Trailer is not available at the moment."
        noTrailerLabel.textAlignment = .center
        noTrailerLabel.isHidden = true
        noTrailerLabel.textColor = .darkGray
    }
    
    private func displayMovieDetails() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title.isEmpty ? "Title not available" : movie.title
        titleLabel.font = movie.title.isEmpty ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 18)
        
        overviewLabel.text = movie.overview.isEmpty ? "Overview not available" : movie.overview
        overviewLabel.font = movie.overview.isEmpty ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        let genres = NetworkService.shared.getGenres(for: movie.genreIds)
        genreLabel.text = genres.isEmpty ? "Genres not available" : "\(genres)"
        genreLabel.font = genres.isEmpty ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        yearLabel.text = movie.releaseDate?.split(separator: "-").first.map { String($0) } ?? "Release date not available"
        yearLabel.font = (movie.releaseDate?.isEmpty ?? true) ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        if let voteAverage = movie.voteAverage {
            ratingLabel.text = String(format: "%.2f/10", voteAverage)
        } else {
            ratingLabel.text = "Rating not available"
        }
        
        ratingLabel.font = (movie.voteAverage == nil) ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        if let posterPath = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func fetchTrailer() {
        guard let movieID = movie?.id else { return }
        let urlString = "\(NetworkService.shared.baseURL)/movie/\(movieID)/videos?api_key=\(NetworkService.shared.apiKey)&language=en-US"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                let trailerResponse = try JSONDecoder().decode(TrailerResponse.self, from: data)
                if let trailer = trailerResponse.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" }) {
                    DispatchQueue.main.async {
                        self.trailerID = trailer.key
                        self.noTrailerLabel.isHidden = true
                        self.playerView.isHidden = false
                        self.playerView.load(withVideoId: trailer.key)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.noTrailerLabel.isHidden = false
                        self.playerView.isHidden = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.noTrailerLabel.isHidden = false
                    self.playerView.isHidden = true
                }
            }
        }.resume()
    }
}
