//
//  BookCell.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/07.
//

import UIKit

final class BookCell: UITableViewCell {
    static let identifier = "BookCell"
    
    private lazy var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var bookTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var spacingView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var labelsVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, bookTypeLabel, spacingView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var bookInfoHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookImageView, labelsVStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(bookInfoHStackView)
        
        bookInfoHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
        }
    }
    
    func configure(with book: Item, bookType: BookType) async {
        titleLabel.text = book.volumeInfo.title
        setAuthorLabel(book.volumeInfo.authors)
        bookTypeLabel.text = bookType.description
        let imageURL = book.volumeInfo.imageLinks?.smallThumbnail ?? ""
        await configureImage(imageURL)
    }
    
    private func configureImage(_ imageURL: String) async {
        do {
            let image = try await UIImage().downloadImage(from: imageURL)
            bookImageView.image = image
        } catch {
            bookImageView.image = .defaultImage
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
