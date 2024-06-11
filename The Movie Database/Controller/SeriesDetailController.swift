//
//  SeriesDetailViewController.swift
//  The Movie Database
//
//  Created by NIKITA on 22.05.2024.
//


import UIKit
import youtube_ios_player_helper

class SeriesDetailController: UIViewController {
    var series: TVSeries?
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
        displaySeriesDetails()
        fetchTrailer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupUI() {
        title = "Series Details"
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(genreLabel)
        view.addSubview(yearLabel)
        view.addSubview(ratingLabel)
        view.addSubview(playerView)
        view.addSubview(noTrailerLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(200)
        }
        
        noTrailerLabel.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(200)
            make.bottom.equalTo(contentView).offset(-16)
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
    
    private func displaySeriesDetails() {
        guard let series = series else { return }
        
        titleLabel.text = series.name.isEmpty ? "Title not available" : series.name
        titleLabel.font = series.name.isEmpty ? UIFont.systemFont(ofSize: 14) : UIFont.boldSystemFont(ofSize: 18)
        
        overviewLabel.text = series.overview.isEmpty ? "Overview not available" : series.overview
        overviewLabel.font = series.overview.isEmpty ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        let genres = NetworkService.shared.getGenres(for: series.genreIds)
        genreLabel.text = genres.isEmpty ? "Genres not available" : "\(genres)"
        genreLabel.font = genres.isEmpty ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        yearLabel.text = series.releaseDate?.split(separator: "-").first.map { String($0) } ?? "Release date not available"
        yearLabel.font = (series.releaseDate?.isEmpty ?? true) ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        if let voteAverage = series.voteAverage {
            ratingLabel.text = String(format: "%.2f/10", voteAverage)
        } else {
            ratingLabel.text = "Rating not available"
        }
        
        ratingLabel.font = (series.voteAverage == nil) ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 16)
        
        if let posterPath = series.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func fetchTrailer() {
        guard let seriesID = series?.id else { return }
        let urlString = "\(NetworkService.shared.baseURL)/tv/\(seriesID)/videos?api_key=\(NetworkService.shared.apiKey)&language=en-US"
        
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
