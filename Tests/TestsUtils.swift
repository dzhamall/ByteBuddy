//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation
@testable import ByteBuddy

enum TestsUtils {
    static func getSnapshotURL(_ filename: String = #file) throws -> URL {
        let name = URL(fileURLWithPath: "\(filename)", isDirectory: false).deletingPathExtension().lastPathComponent
        let resourceURL = try Bundle.module.resourceURL.unwrap()
        return URL(fileURLWithPath: "MemorySnapshots/\(name).json", isDirectory: true, relativeTo: resourceURL)
    }
}
