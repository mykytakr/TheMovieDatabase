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

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        watchLaterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: watchLaterButton.leadingAnchor, constant: -8),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            genreLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 4),
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),

            yearLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),

            ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),

            watchLaterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            watchLaterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            watchLaterButton.widthAnchor.constraint(equalToConstant: 30),
            watchLaterButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)

        overviewLabel.numberOfLines = 3
        overviewLabel.textColor = .gray

        genreLabel.numberOfLines = 1
        genreLabel.textColor = .darkGray

        yearLabel.numberOfLines = 1
        yearLabel.textColor = .darkGray

        ratingLabel.numberOfLines = 1
        ratingLabel.textColor = .darkGray

        watchLaterButton.setImage(UIImage(systemName: "clock"), for: .normal)
        watchLaterButton.addTarget(self, action: #selector(toggleWatchLater), for: .touchUpInside)
    }

    func configure(with series: TVSeries, showWatchLaterButton: Bool = true) {
        self.series = series
        titleLabel.text = series.name
        overviewLabel.text = series.overview
        genreLabel.text = NetworkService.shared.getGenres(for: series.genreIds)
        yearLabel.text = series.releaseDate?.split(separator: "-").first.map { String($0) } ?? "Unknown Year"
        ratingLabel.text = series.voteAverage != nil ? "Rating: \(series.voteAverage!)/10" : "No Rating"
        if let posterPath = series.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: url)
        }
        watchLaterButton.isHidden = !showWatchLaterButton
        updateWatchLaterButton()
    }

    @objc private func updateWatchLaterButton() {
        guard let series = series else { return }
        if WatchLaterManager.shared.isSeriesInWatchLater(series) {
            watchLaterButton.setImage(UIImage(systemName: "clock.fill"), for: .normal)
        } else {
            watchLaterButton.setImage(UIImage(systemName: "clock"), for: .normal)
        }
    }

    @objc private func toggleWatchLater() {
        guard let series = series else { return }
        if WatchLaterManager.shared.isSeriesInWatchLater(series) {
            WatchLaterManager.shared.removeSeriesFromWatchLater(series)
        } else {
            WatchLaterManager.shared.addSeriesToWatchLater(series)
        }
    }
}
