//  Shared.swift
//  Created by dzhamall

import Foundation

public struct HeapOutput: Codable, Equatable {
    public let className: String
    public let type: String?
    public let binary: String?
    public let count: Int
    public let bytes: Int
    public let avg: Int

    public init(className: String, type: String?, binary: String?, count: Int, bytes: Int, avg: Int) {
        self.className = className
        self.type = type
        self.binary = binary
        self.count = count
        self.bytes = bytes
        self.avg = avg
    }

    internal init(object: HeapEntity.Object, value: HeapEntity.Value) {
        self.className = object.className
        self.type = object.type
        self.binary = object.binary
        self.count = value.count
        self.bytes = value.bytes
        self.avg = value.avg
    }
}
