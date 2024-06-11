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
        
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        noTrailerLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-16)
        }
        
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
