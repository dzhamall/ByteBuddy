//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import XCTest

public extension XCUIApplication {
    /// Mockapp process identifier
    var pid: Int? {
        value(forKey: "processID") as? Int
    }
}
