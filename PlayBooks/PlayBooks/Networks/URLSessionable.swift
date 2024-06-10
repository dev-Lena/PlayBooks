//
//  URLSessionable.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/04.
//

import Foundation

protocol URLSessionable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
