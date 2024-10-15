//  Shared.swift
//  Created by dzhamall

import Foundation

public struct LeaksOutput {
    public let count: Int
    public let message: String

    public init(count: Int, message: String) {
        self.count = count
        self.message = message
    }
}
