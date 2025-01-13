//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

// MARK: - Dictionary + HeapEntity

extension Dictionary where Value == HeapEntity.Value, Key == HeapEntity.Object {
    mutating func increment(for element: Key, value: Value) {
        self[element, default: HeapEntity.Value(count: 0, bytes: 0)].append(count: value.count, bytes: value.bytes)
    }

    /// If the number of items in the dictionary is less, it returns the difference.
    @discardableResult
    mutating func decrement(for element: Key, value: Value) -> (Key, Value)? {
        guard let objectValue = self[element] else {
            return nil
        }

        let result = objectValue.count - value.count
        guard result >= 0 else  {
            self[element] = nil
            return (
                element,
                HeapEntity.Value(count: abs(result), bytes: value.avg * abs(result))
            )
        }

        self[element] = result > 0
            ? HeapEntity.Value(count: result, bytes: objectValue.bytes - value.bytes)
            : nil

        return nil
    }
}

// MARK: - Environment

extension Environment {
    var localhost: String {
        "http://localhost:\(port)"
    }
}

// MARK: - Optional

extension Optional {
    func unwrap() throws -> Wrapped {
        switch self {
        case .none:
            throw Common.Error.unexpectedNil(Wrapped.self)

        case let .some(wrapped):
            return wrapped
        }
    }
}
