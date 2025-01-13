//  Shared.swift
//  Created by dzhamall

import Foundation
import OSLog

public enum Common {
    public static let urlPath = "/bytebyddy"

    public enum Error: Swift.Error {
        case urlIsNotValid(_ url: String)
        case noHttpResponse
        case unexpectedHttpStatusCode(_ response: HTTPURLResponse)

        case shellError(output: String?)
        case parsingError(output: Data)

        case unexpectedNil(Any.Type, file: String = #fileID)
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
    private static let osLog = OSLog(subsystem: "\(prefix).log", category: "ByteBuddyLib")

    public static func log(
        _ message: String,
        level: OSLogType = .info,
        file: String = #file,
        function: String = #function
    ) {
        os_log("%{public}s", log: osLog, type: level, message)
    }
}
