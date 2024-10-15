//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

@frozen
enum Command: String {
    case leaks, heap
}

extension Command {
    func asURLRequest(env: Environment) throws -> URLRequest {
        let urlString = env.localhost + ByteBuddy.urlPath
        guard let url = URL(string: urlString) else {
            throw ByteBuddy.Error.urlIsNotValid(urlString)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        let headerFields = getHeaderFields(env: env)
        headerFields.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

// MARK: - Private

private extension Command {
    var httpMethod: String {
        switch self {
        case .leaks, .heap:
            return "GET"
        }
    }

    func getHeaderFields(env: Environment) -> [String: String] {
        [
            HeaderFieldKey.cmd.rawValue: rawValue,
            HeaderFieldKey.pid.rawValue: env.pid
        ]
    }
}
