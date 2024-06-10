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
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
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
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var bookInfoHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, labelsVStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
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
            make.edges.equalToSuperview().inset(20)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
        }
    }
    
    func configure(with book: Book?) async {
        guard let book = book else { return }
        titleLabel.text = book.volumeInfo?.title
        setAuthorLabel(book.volumeInfo?.authors)
        bookTypeLabel.text = book.volumeInfo?.printType
        totalPagesLabel.text = " ·  \(book.volumeInfo?.pageCount) 페이지"
        let imageUrl = book.volumeInfo?.imageUrls?.thumbnail ?? ""
        await configureImage(imageUrl)
    }
    
    private func configureImage(_ imageURL: String) async {
        do {
            let image = try await UIImage().downloadImage(from: imageURL)
            thumbnailImageView.image = image
        } catch {
            thumbnailImageView.image = .defaultImage
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
