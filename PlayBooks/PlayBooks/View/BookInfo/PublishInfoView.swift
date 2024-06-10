//
//  PublishInfoView.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/10.
//

import UIKit

final class PublishInfoView: UIView {
    private lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "게시일"
        return label
    }()
    
    private lazy var publishedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var infoLabelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [publishedDateLabel,publisherLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var labelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sectionTitleLabel,infoLabelsVStackView])
        stackView.axis = .vertical
        stackView.spacing = 5
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
    
    func configure(with publishedDate: String, publisher: String) {
        publishedDateLabel.text = "출판일: \(publishedDate)"
        publisherLabel.text = "출판사: \(publisher)"
    }
}
