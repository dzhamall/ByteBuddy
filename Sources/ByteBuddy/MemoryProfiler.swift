//  MemoryProfiler.swift
//  Created by dzhamall

import Foundation
import Shared

typealias InternalError = ByteBuddy.Error

public struct MemoryProfiler {
    private let env: Environment

    public init(env: Environment) {
        self.env = env
    }

    public func detectLeaks() async throws -> LeaksOutput {
        let data = try await execute(.leaks)
        let leaksOutput = try Parser.parseLeaksOutput(data)
        return leaksOutput
    }
}

// MARK: - Private

private extension MemoryProfiler {
    func execute(_ command: Command) async throws -> Data {
        let request = try command.asURLRequest(env: env)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw InternalError.noHttpResponse
        }

        guard response.statusCode == 200 else {
            throw InternalError.unexpectedHttpStatusCode(response)
        }

        return data
    }
}
