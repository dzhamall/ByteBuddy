//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation
@testable import ByteBuddy

final class NetworkSessionMock {
    let data: Data
    let response: URLResponse

    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
}

extension NetworkSessionMock: NetworkSession {
    func loadData(for request: URLRequest) async throws -> (Data, URLResponse) {
        (data, response)
    }
}
