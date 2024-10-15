//  Shared.swift
//  Created by dzhamall

import Foundation
import os

public enum ByteBuddy {
    public static let urlPath = "/bytebyddy"

    public enum Error: Swift.Error {
        case urlIsNotValid(_ url: String)
        case noHttpResponse
        case unexpectedHttpStatusCode(_ response: HTTPURLResponse)

        case shellError(output: String?)
        case parsingError(output: Data)

        case unknown
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
