//
//  Endpoint.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//

import Foundation

enum BookType: String {
    case allBooks
    case eBooks = "ebooks"
}

enum Endpoint {
    case searchBooks(query: String, startIndex: Int, maxResults: Int, bookType: BookType)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/books/v1/volumes"
        
        switch self {
        case .searchBooks(
            let query,
            let startIndex,
            let maxResults,
            let bookType):
            components.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "maxResults", value: "\(maxResults)"),
                URLQueryItem(name: "startIndex", value: "\(startIndex)"),
            ]
            if bookType == .eBooks {
                components.queryItems?
                    .append(URLQueryItem(name: "filter", value: "ebooks"))
            }
        }
        return components.url
    }
}
