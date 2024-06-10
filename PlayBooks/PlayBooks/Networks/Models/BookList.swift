//
//  BookList.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//

import Foundation

// MARK: - SearchResults
struct BookList: Codable {
    let totalItems: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    
    let id: String
    let volumeInfo: BookInfo
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let country: String
    let epub, pdf: Epub
    let webReaderLink: String
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: String
    let isEbook: Bool
}

// MARK: - VolumeInfo
struct BookInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher, description: String?
    let publishedDate: String?
    let pageCount: Int?
    let imageLinks: ImageLinks?
    let language: String?
    let infoLink: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return (lhs.id == rhs.id)
    }
}
