//
//  BookDetailView.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/10.
//

import UIKit

final class BookDetailView: UIView {
    private lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "책 정보"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sectionTitleLabel, descriptionLabel])
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
            make.top.equalToSuperview().offset(10)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with description: String) {
        descriptionLabel.text = "\(description)"
    }
}
