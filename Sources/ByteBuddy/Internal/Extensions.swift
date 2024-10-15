//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

extension Dictionary where Value == Int, Key == HeapOutput.Object {
    mutating func increment(for element: Key) {
        self[element, default: 0] += element.count
    }

    mutating func decrement(for element: Key) {
        guard let count = self[element] else { return }
        self[element] = ((count - element.count) > 1) ? count - element.count : nil
    }
}
