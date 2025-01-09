//  Shared.swift
//  Created by dzhamall

import Foundation
import Shared

struct HeapEntity: Equatable {
    struct Object: Hashable {
        let className: String
        let type: String?
        let binary: String?

        init(className: String, type: String?, binary: String?) {
            self.className = className
            self.type = type
            self.binary = binary
        }
    }

    struct Value: Equatable {
        private(set) var count: Int
        private(set) var bytes: Int

        var avg: Int {
            bytes / count
        }

        init?(count: String, bytes: String) {
            guard
                let countVal = Int(count),
                let bytesVal = Int(bytes)
            else {
                Logger.log("Can't convert count – \(count) or bytes – \(bytes)", level: .error)
                return nil
            }

            self.count = countVal
            self.bytes = bytesVal
        }

        init(count: Int, bytes: Int) {
            self.count = count
            self.bytes = bytes
        }

        mutating func append(count: Int, bytes: Int) {
            self.count += count
            self.bytes += bytes
        }

        mutating func remove(count: Int, bytes: Int) {
            self.count -= count
            self.bytes -= bytes
        }
    }

    let objects: [Object: Value]

    init(objects: [Object: Value]) {
        self.objects = objects
    }
}
