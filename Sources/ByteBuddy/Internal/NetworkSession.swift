//  ByteBuddy.swift
//  Created by dzhamall

import Foundation

protocol NetworkSession: AnyObject {
    func loadData(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension NetworkSession where Self: URLSession {
    func loadData(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}

extension URLSession: NetworkSession {}
