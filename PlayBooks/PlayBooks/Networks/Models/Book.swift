//
//  Book.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//

import Foundation

// MARK: - Book
struct Book: Codable {
    let kind, id, etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let publisher, publishedDate: String
    let pageCount: Int
    let printType, maturityRating: String
    let contentVersion: String
    let language: String
    let previewLink: String
    let infoLink: String
}
