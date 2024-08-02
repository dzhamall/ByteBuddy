//  Shared.swift
//  Created by dzhamall

import Foundation
import os

public enum ByteBuddy {
    public static let urlPath = "/bytebyddy"

    public enum Error: Swift.Error {
        case urlIsNotValid(_ url: String)
        case serviceError(Swift.Error)
        case noHttpResponse
        case unexpectedHttpStatusCode(_ response: HTTPURLResponse)
        case noData(_ response: HTTPURLResponse)

        case shellError(output: String?)
        case parsingError(output: Data)

        case leaksFoud(output: LeaksOutput)

        case unknown
    }
}

// MARK: - Outputs

public struct LeaksOutput {
    public let count: Int
    public let message: String

    public init(count: Int, message: String) {
        self.count = count
        self.message = message
    }
}

// MARK: - HeaderFieldKey

@frozen
public enum HeaderFieldKey: String {
    case cmd = "command"
    case pid = "process_identifier"
}

// MARK: - Logger

@frozen
public enum Logger {
    private static let prefix = "📟 ByteBuddy"
    private static let osLogger = os.Logger(subsystem: "\(prefix).logger", category: "lib")

    public static func log(_ message: String, level: OSLogType = .info) {
        osLogger.log(level: level, "[\(prefix)]: \(message)")
    }
}