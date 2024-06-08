//
//  NetworkTests.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/05.
//

import XCTest
@testable import PlayBooks

final class NetworkTests: XCTestCase {
    
    var networkManager: NetworkRequestable!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
    
    // MARK: URL 생성이 제대로 되고 있는지 확인
    func testEndpoint_URLCreation() {
        // All Books URL
        let allBookEndpoint = Endpoint.searchBooks(query: "iOS", startIndex: 0, maxResults: 20, bookType: .allBooks)
        let allBooksUrl = allBookEndpoint.url
        XCTAssertEqual(allBooksUrl?.absoluteString, "https://www.googleapis.com/books/v1/volumes?q=iOS&maxResults=20&startIndex=0", "이 메시지가 보인다면, ❌ 의도하지 않은 allBooksUrl이 생성되었습니다")
        
        // eBooks URL
        let eBookEndpoint = Endpoint.searchBooks(query: "iOS", startIndex: 20, maxResults: 40, bookType: .eBooks)
        let eBooksUrl = eBookEndpoint.url
        XCTAssertEqual(eBooksUrl?.absoluteString, "https://www.googleapis.com/books/v1/volumes?q=iOS&maxResults=40&startIndex=20&filter=ebooks", "이 메시지가 보인다면, ❌ 의도하지 않은 eBooksUrl이 생성되었습니다")
    }
    
    // MARK: API 요청 후 Response를 제대로 가지고 오는지 확인
    func testFetchData_SuccessfulResponse() async throws {
        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        let expectedData = "{\"title\": \"Test Book\"}".data(using: .utf8)!
        let expectedResponse = HTTPURLResponse(url: endpoint.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.data = expectedData
        mockSession.response = expectedResponse

        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success(let book):
            XCTAssertEqual(book.title, "Test Book", "이 메시지가 보인다면, ❌ 요청 후 Response를 제대로 가져오는 데 실패했습니다.")
        case .failure:
            XCTFail("이 메시지가 보인다면, ❌ 요청이 실패했습니다.")
        }
    }

    // MARK: 400 클라이언트 에러 발생 시, 제대로된 에러를 던지는지 확인
    func testFetchData_ClientErrorResponse() async throws {

        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        let expectedResponse = HTTPURLResponse(url: endpoint.url!, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockSession.response = expectedResponse
        mockSession.data = Data() // 빈 데이터 설정
        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success:
            XCTFail("이 메시지가 보인다면, ❌ HTTP status code 400 발생하였음에도 클라이언트 요청 에러를 던지지 않았습니다.")
        case .failure(let error):
            if case .clientError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("이 메시지가 보인다면, ❌ 에러가 발생하여 에러를 던졌지만 제대로 된 에러(clientError)를 던지지 않았습니다. error:\(error)")
            }
        }
    }

    // MARK: 500 서버 에러 발생 시, 제대로된 에러를 던지는지 확인
    func testFetchData_ServerErrorResponse() async throws {
        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        let expectedResponse = HTTPURLResponse(url: endpoint.url!, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockSession.response = expectedResponse
        mockSession.data = Data() // 빈 데이터 설정

        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success:
            XCTFail("이 메시지가 보인다면, ❌ HTTP status code 500 발생하였음에도 서버 에러를 던지지 않았습니다.")
        case .failure(let error):
            if case .serverError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("❌ 에러가 발생하여 에러를 던졌지만 제대로 된 에러(serverError)를 던지지 않았습니다. error:\(error)")
            }
        }
    }

    // MARK: 요청 후 알수 없는 응답 에러 발생 시, 제대로된 에러를 던지는지 확인
    func testFetchData_UnknownErrorResponse() async throws {
        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        let expectedResponse = HTTPURLResponse(url: endpoint.url!, statusCode: 600, httpVersion: nil, headerFields: nil)
        mockSession.response = expectedResponse

        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success:
            XCTFail("❌ 요청 후 Response에서 에러가 발생하였음에도 에러를 던지지 않았습니다.")
        case .failure(let error):
            if case .responseError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("❌ 요청 후 Response에서 에러가 발생하여 에러를 던졌지만 제대로 된 에러(responseError)를 던지지 않았습니다. error:\(error)")
            }
        }
    }

    // MARK: 인터넷 연결이 되어있지 않는 경우, 제대로된 에러를 던지는지 확인
    func testFetchData_URLError() async throws {
        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        mockSession.error = URLError(.notConnectedToInternet)

        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success:
            XCTFail("❌ URLError가 발생하였음에도 에러를 던지지 않았습니다.")
        case .failure(let error):
            if case .networkError(let urlError) = error {
                XCTAssertEqual(urlError.code, .notConnectedToInternet, "❌ 에러가 발생하여 URLError 에러를 던졌으나 제대로 된 에러(notConnectedToInternet)를 던지지 않았습니다. error: \(error)")
            } else {
                XCTFail("❌ 에러가 발생하여 에러를 던졌지만 제대로 된 에러(networkError)를 던지지 않았습니다.")
            }
        }
    }

    // MARK: 디코딩 에러 발생 시, 제대로된 에러를 던지는지 확인
    func testFetchData_DecodingError() async throws {
        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        let invalidData = "invalid json".data(using: .utf8)!
        let expectedResponse = HTTPURLResponse(url: endpoint.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.data = invalidData
        mockSession.response = expectedResponse

        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success:
            XCTFail("❌ Decoding에러가 발생하였음에도 에러를 던지지 않았습니다.")
        case .failure(let error):
            if case .decodingError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("❌ 에러가 발생하여 에러를 던졌지만 제대로 된 에러(decodingError)를 던지지 않았습니다.")
            }
        }
    }

    // MARK: 알 수 없는 에러 발생 시, 제대로된 에러를 던지는지 확인
    func testFetchData_UnknownError() async throws {
        // Given
        let endpoint = Endpoint.searchBooks(query: "swift", startIndex: 0, maxResults: 20, bookType: .allBooks)
        mockSession.error = NSError(domain: "Test", code: 999, userInfo: nil)

        // When
        let result: Result<MockBook, NetworkError> = await networkManager.fetchData(for: endpoint, dataType: MockBook.self)

        // Then
        switch result {
        case .success:
            XCTFail("❌ 알 수 없는 에러가 발생하였음에도 에러를 던지지 않았습니다.")
        case .failure(let error):
            if case .unknownError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("❌ 알 수 없는 에러가 발생하여 에러를 던졌지만 제대로 된 에러(unknownError)를 던지지 않았습니다.")
            }
        }
    }
}
