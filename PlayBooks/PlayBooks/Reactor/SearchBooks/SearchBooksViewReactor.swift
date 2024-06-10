//
//  SearchBooksViewReactor.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/06.
//

import ReactorKit
import RxSwift

class SearchBooksViewReactor: Reactor {
    enum Action {
        case search(query: String)
        case loadMore
        case refresh
        case selectTab(BookType)
    }
    
    enum Mutation {
        case setBooks(BookList)
        case appendBooks([Item])
        case setLoading(Bool)
        case setError(NetworkError?)
        case setTab(BookType)
        case setQuery(String)
        case setEmpty(Bool)
    }
    
    struct State {
        var books: [Item] = []
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        var error: NetworkError?
        var currentTab: BookType = .allBooks
        var query: String = ""
        var totalCount: Int = 0
        var isEmpty: Bool = true
    }
    
    let initialState = State()
    
    private let searchBooksRepository: SearchRepository
    private let requestDataCount = 20
    
    init(searchBooksRepository: SearchRepository = SearchRepositoryImpl()) {
        self.searchBooksRepository = searchBooksRepository
    }
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(query):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                searchBooks(query: query, startIndex: 0)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let response):
                            return Mutation.setBooks(response)
                        case .failure(let error):
                            return Mutation.setError(error)
                        }
                    },
                Observable.just(Mutation.setQuery(query)),
                Observable.just(Mutation.setEmpty(false)),
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .loadMore:
            guard !self.currentState.isLoading else { return .empty() }
            guard self.currentState.books.count < self.currentState.totalCount else { return .empty() }
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                searchBooks(query: currentState.query, startIndex: currentState.books.count)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let response):
                            return Mutation.appendBooks(response.items)
                        case .failure(let error):
                            return Mutation.setError(error)
                        }
                    },
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .refresh:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                searchBooks(query: currentState.query, startIndex: 0)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let response):
                            return Mutation.setBooks(response)
                        case .failure(let error):
                            return Mutation.setError(error)
                        }
                    },
                Observable.just(Mutation.setLoading(false))
            ])
            
        case let .selectTab(bookType):
            return Observable.concat([
                Observable.just(Mutation.setTab(bookType)),
                Observable.just(Mutation.setLoading(true)),
                searchBooks(query: currentState.query, startIndex: currentState.books.count)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let response):
                            return Mutation.setBooks(response)
                        case .failure(let error):
                            return Mutation.setError(error)
                        }
                    },
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    private func searchBooks(query: String, startIndex: Int) -> Single<Result<BookList, NetworkError>> {
        return searchBooksRepository.fetchSearchBooks(
            query: query,
            startIndex: startIndex,
            maxResults: self.requestDataCount,
            tabType: currentState.currentTab)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setBooks(bookList):
            newState.books = bookList.items
            newState.totalCount = bookList.totalItems
            
        case let .appendBooks(books):
            newState.books.append(contentsOf: books)
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setError(error):
            newState.error = error
            
        case let .setTab(bookType):
            newState.currentTab = bookType
            
        case let .setQuery(query):
            newState.query = query
            
        case let .setEmpty(isEmpty):
            newState.isEmpty = isEmpty
        }
        return newState
    }
}
