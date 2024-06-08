//
//  NetworkRequestable.swift
//  PlayBooks
//
//  Created by Keunna Lee on 2024/06/08.
//

import Foundation

protocol NetworkRequestable: AnyObject {
    func fetchData<T: Decodable>(for url: Endpoint,
                                  dataType: T.Type) async -> Result<T, NetworkError>
}
