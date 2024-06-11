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

// MARK: - VolumeInfo
struct BookInfo: Codable {
    let title: String
    let authors: [String]?
    let imageLinks: ImageLinks?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return (lhs.id == rhs.id)
    }
}
