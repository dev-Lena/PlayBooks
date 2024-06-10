//
//  RatingView.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/09.
//

import UIKit
import Cosmos

final class RatingView: UIView {
    private lazy var totalRatingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var ratingView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starSize = 18
        cosmosView.settings.starMargin = 5
        cosmosView.settings.filledColor = .black
        cosmosView.settings.emptyBorderColor = .black
        cosmosView.settings.filledBorderColor = .black
        return cosmosView
    }()
    
    private lazy var totalRatingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    private lazy var ratingHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalRatingsLabel, ratingView])
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var labelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingHStackView, totalRatingCountLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(labelsVStackView)
        
        labelsVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with rating: Int?, counts: Int?) {
        guard let rating = rating, let counts = counts else { return }
        ratingView.rating = Double(rating)
        totalRatingsLabel.text = "\(Double(rating))"
        totalRatingCountLabel.text = "Google Play 평점 \(counts)개"
    }
}
