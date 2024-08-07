//
//  BookInfoViewController.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/07.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import WebKit

class BookInfoViewController: UIViewController, View {
    typealias Reactor = BookInfoReactor
    var disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(BookInfoCell.self, forCellReuseIdentifier: BookInfoCell.identifier)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var bookSummaryInfoView: BookSummaryInfoView = {
        let view = BookSummaryInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonsView: ButtonsView = {
        let view = ButtonsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bookDetailView: BookDetailView = {
        let view = BookDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var publishInfoView: PublishInfoView = {
        let view = PublishInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var bookId: String = ""
    private var thumbnailImage: UIImage = UIImage()
    
    var webView: WKWebView!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    init(id: String, thumbnail: UIImage) {
        self.bookId = id
        self.thumbnailImage = thumbnail
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        setupViews()
        self.reactor = BookInfoReactor()
        self.reactor?.action.onNext(.setBookId(self.bookId))
    }
    
    private func setupViews() {
        view.addSubviews(tableView, bookSummaryInfoView, buttonsView, ratingView, bookDetailView, publishInfoView)
        view.backgroundColor = .white
        self.navigationItem.title = "도서정보"
        self.navigationItem.backBarButtonItem?.tintColor = .black
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    func bind(reactor: BookInfoReactor) {
        reactor.state.map { $0.bookId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] id in
                self?.reactor?.action.onNext(.loadBookInfo(id: id))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bookInfo }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bookInfo in
                guard let self = self, let book = bookInfo.volumeInfo else { return }
                self.bookSummaryInfoView.configure(with: bookInfo, thumbnail: self.thumbnailImage)
                self.ratingView.configure(with: book.averageRating, counts: book.ratingsCount)
                self.bookDetailView.configure(with: book.description ?? "")
                self.publishInfoView.configure(with: book.publishedDate ?? "", publisher: book.publisher ?? "")
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension BookInfoViewController: ButtonsViewDelegate {
    func didBuyButtonTapped() {
        let alert = UIAlertController(title: "구매 링크로 이동합니다", message: "이동하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            [weak self] _ in
            self?.presentWebView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
        
    }
    
    func didsalesInfoButtonTapped() {
        guard let bookInfo = self.reactor?.currentState.bookInfo else { return }
        
        let viewController = SalesInfoHalfViewController(book: bookInfo)
        viewController.view.backgroundColor = .white
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }
    
    private func presentWebView() {
        guard let infoLink = self.reactor?.currentState.bookInfo?.volumeInfo?.infoLink, let url = URL(string: infoLink) else { return }
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        let request = URLRequest(url: url)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
}
extension BookInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewPartCount: Int = 5
        return viewPartCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookInfoCell.identifier, for: indexPath) as? BookInfoCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        switch indexPath.row {
        case 0:
            cell.contentView.addSubview(bookSummaryInfoView)
            bookSummaryInfoView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case 1:
            cell.contentView.addSubview(buttonsView)
            buttonsView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case 2:
            cell.contentView.addSubview(ratingView)
            ratingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case 3:
            cell.contentView.addSubview(bookDetailView)
            bookDetailView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case 4:
            cell.contentView.addSubview(publishInfoView)
            publishInfoView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        default:
            break
        }
        return cell
    }
    
}

extension BookInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

extension BookInfoViewController: WKNavigationDelegate {}
