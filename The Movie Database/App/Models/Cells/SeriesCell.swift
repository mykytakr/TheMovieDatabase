//
//  SeriesCell.swift
//  The Movie Database
//
//  Created by NIKITA on 22.05.2024.
//


import UIKit
import Kingfisher

class SeriesCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let watchLaterButton = UIButton(type: .system)
    private var series: TVSeries?

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

    func configure(with series: TVSeries, showWatchLaterButton: Bool = true) {
        self.series = series
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

        watchLaterButton.isHidden = !showWatchLaterButton
        updateWatchLaterButton()
    }

    @objc private func updateWatchLaterButton() {
        guard let series = series else { return }
        let isInWatchLater = WatchLaterManager.shared.isSeriesInWatchLater(series)
        let imageName = isInWatchLater ? "clock.fill" : "clock"
        let imageColor: UIColor = isInWatchLater ? .white : .systemGray
        watchLaterButton.setImage(UIImage(systemName: imageName), for: .normal)
        watchLaterButton.tintColor = imageColor
    }

    @objc private func toggleWatchLater() {
        guard let series = series else { return }
        if WatchLaterManager.shared.isSeriesInWatchLater(series) {
            WatchLaterManager.shared.removeSeriesFromWatchLater(series)
        } else {
            WatchLaterManager.shared.addSeriesToWatchLater(series, success: {
                self.updateWatchLaterButton()
                self.parentViewController?.showAlert(title: "Success", message: "\(series.name) has been added to Watch Later")
            }, failure: {
                self.parentViewController?.showAlert(title: "Failure", message: "Failed to add \(series.name) to Watch Later")
            })
        }
        updateWatchLaterButton()
    }
}
