//
//  MovieCell.swift
//  The Movie Database
//
//  Created by NIKITA on 22.05.2024.
//


import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let watchLaterButton = UIButton(type: .system)
    private var movie: Movie?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.backgroundColor = .black
        backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(updateWatchLaterButton), name: NSNotification.Name("WatchLaterUpdated"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("WatchLaterUpdated"), object: nil)
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(watchLaterButton)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.bottom.lessThanOrEqualTo(contentView).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(watchLaterButton.snp.leading).offset(-8)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        watchLaterButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        
        overviewLabel.numberOfLines = 3
        overviewLabel.textColor = .lightGray
        
        genreLabel.numberOfLines = 1
        genreLabel.textColor = .gray
        
        yearLabel.numberOfLines = 1
        yearLabel.textColor = .gray
        
        ratingLabel.numberOfLines = 1
        ratingLabel.textColor = .gray
        
        watchLaterButton.addTarget(self, action: #selector(toggleWatchLater), for: .touchUpInside)
        updateWatchLaterButton()
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .black
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configure(with movie: Movie, showWatchLaterButton: Bool = true) {
        self.movie = movie
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
        
        watchLaterButton.isHidden = !showWatchLaterButton
        updateWatchLaterButton()
    }
    
    @objc private func updateWatchLaterButton() {
        guard let movie = movie else { return }
        let isInWatchLater = WatchLaterManager.shared.isMovieInWatchLater(movie)
        let imageName = isInWatchLater ? "clock.fill" : "clock"
        let imageColor: UIColor = isInWatchLater ? .white : .systemGray
        watchLaterButton.setImage(UIImage(systemName: imageName), for: .normal)
        watchLaterButton.tintColor = imageColor
    }
    
    @objc private func toggleWatchLater() {
        guard let movie = movie else { return }
        if WatchLaterManager.shared.isMovieInWatchLater(movie) {
            WatchLaterManager.shared.removeMovieFromWatchLater(movie)
        } else {
            WatchLaterManager.shared.addMovieToWatchLater(movie, success: {
                self.updateWatchLaterButton()
                self.parentViewController?.showAlert(title: "Success", message: "\(movie.title) has been added to Watch Later")
            }, failure: {
                self.parentViewController?.showAlert(title: "Failure", message: "Failed to add \(movie.title) to Watch Later")
            })
        }
        updateWatchLaterButton()
    }
}
