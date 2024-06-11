//
//  BookInfoReactor.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/06.
//

import ReactorKit
import RxSwift

class BookInfoReactor: Reactor {
    enum Action {
        case loadBookInfo(id: String)
        case setBookId(String)
    }
    enum Mutation {
        case setBookInfo(Book)
        case setLoading(Bool)
        case setError(NetworkError?)
        case updateBookId(String)
    }
    
    struct State {
        var bookInfo: Book?
        var bookId: String?
        var isLoading: Bool = false
        var error: NetworkError?
    }
    
    let initialState = State()
    private let repository: BookInfoRepository
    
    init(repository: BookInfoRepository = BookInfoRepositoryImpl()) {
        self.repository = repository
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loadBookInfo(id):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                repository.fetchBookInfo(id: id)
                    .asObservable()
                    .map { result in
                        switch result {
                        case let .success(book):
                            return Mutation.setBookInfo(book)
                        case .failure(let error):
                            return Mutation.setError(error)
                        }
                    },
                Observable.just(Mutation.setLoading(false))
            ])
        case let .setBookId(id):
            return Observable.just(Mutation.updateBookId(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setBookInfo(bookInfo):
            newState.bookInfo = bookInfo
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .updateBookId(bookId):
            newState.bookId = bookId
        case let .setError(error):
            newState.error = error
        }
        return newState
    }
}
