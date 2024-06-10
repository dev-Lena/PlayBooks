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
    let selfLink: String
    let volumeInfo: BookInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo
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
    let acsTokenLink: String
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: String
    let isEbook: Bool
    let listPrice, retailPrice: SaleInfoListPrice
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Int
    let currencyCode: String
}

// MARK: - SearchInfo
struct SearchInfo: Codable {
    let textSnippet: String
}

// MARK: - VolumeInfo
struct BookInfo: Codable {
    let title: String
    let authors: [String]
    let publisher, publishedDate, description: String
    let pageCount: Int
    let imageLinks: ImageLinks
    let language: String
    let infoLink: String
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}
