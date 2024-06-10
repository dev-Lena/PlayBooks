//
//  SearchBookRepository.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/06.
//
import RxSwift

protocol SearchRepository: AnyObject {
    func fetchSearchBooks(query: String,
                              startIndex: Int,
                              maxResults: Int,
                              tabType: BookType)
-> Single<Result<BookList, NetworkError>>
}

final class SearchRepositoryImpl: SearchRepository {
    private let networkManager: NetworkRequestable
    
    init(networkManager: NetworkRequestable = NetworkManager()) {
        self.networkManager = networkManager
    }
    func fetchSearchBooks(query: String,
                          startIndex: Int,
                          maxResults: Int,
                          tabType: BookType) -> Single<Result<BookList, NetworkError>> {
        let endpoint: Endpoint
        switch tabType {
        case .allBooks:
            endpoint = .searchBooks(query: query,
                                    startIndex: startIndex,
                                    maxResults: maxResults,
                                    bookType: .allBooks)
        case .eBooks:
            endpoint = .searchBooks(query: query,
                                    startIndex: startIndex,
                                    maxResults: maxResults,
                                    bookType: .eBooks)
        }
        
        return Single.create { single in
            Task {
                do {
                    let result: Result<BookList, NetworkError> =
                    await self.networkManager.fetchData(
                        for: endpoint,
                        dataType: BookList.self)
                    single(.success(result))
                }
            }
            return Disposables.create()
        }
    }
}
