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
        view.addSubview(searchBar)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
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
    
}

