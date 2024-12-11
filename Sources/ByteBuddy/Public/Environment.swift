//  ByteBuddy.swift
//  Created by dzhamall

import Foundation

public struct Environment {
    let port: UInt16
    /// Process identifier
    let pid: String

    public init(port: UInt16, pid: String) {
        self.port = port
        self.pid = pid
    }
}
