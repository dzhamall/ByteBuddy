//  Shared.swift
//  Created by dzhamall

import Foundation

public struct HeapOutput: Equatable, Codable {
    public struct Object: Hashable, Codable {
        public let count: Int
        public let bytes: Int
        public let avg: Double
        public let className: String
        public let type: String?
        public let binary: String?

        public init(count: Int, bytes: Int, avg: Double, className: String, type: String?, binary: String?) {
            self.count = count
            self.bytes = bytes
            self.avg = avg
            self.className = className
            self.type = type
            self.binary = binary
        }

        public init?(count: String, bytes: String, avg: String, className: String, type: String?, binary: String?) {
            guard
                let countVal = Int(count),
                let bytesVal = Int(bytes),
                let avgVal = Double(avg)
            else {
                Logger.log("Can't convert count – \(count) or bytes – \(bytes) or avg – \(avg) value", level: .error)
                return nil
            }

            self.count = countVal
            self.bytes = bytesVal
            self.avg = avgVal
            self.className = className
            self.type = type
            self.binary = binary
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.className == rhs.className && lhs.type == rhs.type && lhs.binary == rhs.binary
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(className)
            hasher.combine(type)
            hasher.combine(binary)
        }
    }

    public let objects: [Object]

    public init(objects: [Object]) {
        self.objects = objects
    }
}
