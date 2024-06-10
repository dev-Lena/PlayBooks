//
//  NetworkManager.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//

import Foundation
import RxSwift

// MARK: - NetworkManager
final class NetworkManager: NetworkRequestable {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(for url: Endpoint,
                                  dataType: T.Type) async -> Result<T, NetworkError> {
        guard let url = url.url else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.responseError)
            }

            switch httpResponse.statusCode {
            case 200...299:
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            case 400...499:
                return .failure(.clientError)
            case 500...599:
                return .failure(.serverError)
            default:
                return .failure(.responseError)
            }
        } catch let urlError as URLError {
            return .failure(.networkError(urlError))
        } catch let decodingError as DecodingError {
            return .failure(.decodingError(decodingError))
        } catch {
            return .failure(.unknownError(error))
        }
    }
}
