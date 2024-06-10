//
//  BookInfoRepository.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/06.
//
import RxSwift

protocol BookInfoRepository: AnyObject {
    func fetchBookInfo(id: String) async -> Single<Result<Book, NetworkError>>
}

final class BookInfoRepositoryImpl: BookInfoRepository {
    private let networkManager: NetworkRequestable
    
    init(networkManager: NetworkRequestable = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchBookInfo(id: String) async -> Single<Result<Book, NetworkError>> {
        let endpoint = Endpoint.fetchBook(id: id)
        return Single.create { single in
            Task {
                do {
                    let result: Result<Book, NetworkError> =
                    await self.networkManager.fetchData(
                        for: endpoint,
                        dataType: Book.self)
                    single(.success(result))
                }
            }
            return Disposables.create()
        }
    }
}
