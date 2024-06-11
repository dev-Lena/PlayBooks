//
//  SearchBooksViewController.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/06.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

class SearchBooksViewController: UIViewController, View {
    typealias Reactor = SearchBooksViewReactor
    var disposeBag = DisposeBag()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Play Books"
        searchBar.searchTextField.clearButtonMode = .always
        return searchBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = SegmentedControl(items: ["Book", "eBook"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
        tableView.rowHeight = 100
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        self.reactor = SearchBooksViewReactor()
    }
    
    private func setupUI() {
        view.addSubviews(searchBar, segmentedControl, tableView)
        tableView.delegate = self
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: SearchBooksViewReactor) {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .map { Reactor.Action.search(query: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver()
            .map { Reactor.Action.search(query: "") }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .skip(1)
            .asDriver(onErrorJustReturn: 0)
            .map { $0 == 0 ? BookType.allBooks : BookType.eBooks }
            .map(Reactor.Action.selectTab)
            .drive(reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .observe(on:MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self, let book = self.reactor?.currentState.books[indexPath.row] else { return }
                let imageURL = book.volumeInfo.imageLinks?.thumbnail ?? ""
                Task {
                    let thumbnail = try await  UIImage().downloadImage(from: imageURL)
                    let bookInfoViewController =  BookInfoViewController(id: book.id, thumbnail: thumbnail)
                    self.navigationController?.pushViewController(bookInfoViewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.books }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(cellIdentifier: BookCell.identifier, cellType: BookCell.self)) { index, book, cell in
                Task {
                    await cell.configure(with: book, bookType: reactor.currentState.currentTab)
                }
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEmpty }
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.view.isUserInteractionEnabled = !isLoading
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.error }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "😵Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
