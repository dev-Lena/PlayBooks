//
//  MockURLSession.swift
//  PlayBooksTests
//
//  Created by Keunna Lee on 2024/06/05.
//
import Foundation
import XCTest
@testable import PlayBooks

class MockURLSession: URLSessionable {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}
