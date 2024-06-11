//
//  Book.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//

import Foundation

// MARK: - Book
struct Book: Codable {
    let id: String
    let volumeInfo: BookInformation?
    let saleInfo: SaleInfo?
}

// MARK: - VolumeInfo
struct BookInformation: Codable {
    let title: String?
    let authors: [String]?
    let publisher, publishedDate, description: String?
    let imageUrls: ImageUrls?
    let pageCount: Int?
    let printType: String?
    let averageRating, ratingsCount: Int?
    let infoLink: String?
}

// MARK: - ImageLinks
struct ImageUrls: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let listPrice, retailPrice: SaleInfoListPrice?
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Int?
    let currencyCode: String?
}

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return (lhs.id == rhs.id)
    }
}
