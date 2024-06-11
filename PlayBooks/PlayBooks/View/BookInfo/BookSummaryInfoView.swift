//
//  BookSummaryInfoView.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/09.
//

import UIKit
import SnapKit

class BookSummaryInfoView: UIView {
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bookTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    private lazy var totalPagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    private lazy var spacingView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var labelsHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ bookTypeLabel, spacingView])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var labelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, labelsHStackView, spacingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var bookInfoHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, labelsVStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
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
        addSubview(bookInfoHStackView)
        
        bookInfoHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    func configure(with book: Book?, thumbnail: UIImage) {
        guard let book = book else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = book.volumeInfo?.title
            self.setAuthorLabel(book.volumeInfo?.authors)
            self.bookTypeLabel.text = book.volumeInfo?.printType
            self.totalPagesLabel.text = " ·  \(book.volumeInfo?.pageCount) 페이지"
            self.thumbnailImageView.image = thumbnail
        }
    }
    
    private func setAuthorLabel(_ authors: [String]?) {
        guard let authors = authors else {
            authorLabel.text = nil
            return
        }
        
        authorLabel.text = authors.joined(separator: ", ")
    }
    
}
