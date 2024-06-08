//
//  NetworkError.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case responseError
    case clientError
    case serverError
    case networkError(URLError)
    case decodingError(DecodingError)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "❌ 유효하지 않은 URL입니다"
        case .responseError:
            return "❌ 요청 후 응답 에러가 발생했습니다."
        case .clientError:
            return "❌ 400 클라이언트 요청 에러가 발생했습니다."
        case .serverError:
            return "❌ 500 서버 에러가 발생했습니다."
        case .networkError(let urlError):
            return "❌ \(urlError.localizedDescription)"
        case .decodingError:
            return "❌ 디코딩 에러가 발생했습니다."
        case .unknownError:
            return "❌ 알 수 없는 에러가 발생했습니다."
        }
    }
}

