//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

extension Parser {
    enum Heap {
        static func parseHeapOutput(_ data: Data, isIncluded: (HeapOutput.Object) -> Bool) throws -> HeapOutput {
            guard let dataLines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines).dropFirst(36) else {
                throw Common.Error.parsingError(output: data)
            }

            let objects = dataLines.compactMap { line -> HeapOutput.Object? in
                let object = parseHeapOutput(line: line)

                guard let object, isIncluded(object) else {
                    return nil
                }

                return object
            }

            return HeapOutput(objects: objects)
        }

        static func parseHeapOutput(
            _ data: Data,
            isIncluded: (HeapOutput.Object) -> Bool
        ) throws -> ([HeapOutput.Object: Int], [HeapOutput.Object]) {
            guard let dataLines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines).dropFirst(36) else {
                throw Common.Error.parsingError(output: data)
            }

            var objects = [HeapOutput.Object: Int]()
            var collisions = [HeapOutput.Object]()

            dataLines.forEach { line in
                let object = parseHeapOutput(line: line)

                guard let object, isIncluded(object) else {
                    return
                }

                if objects.keys.contains(object) {
                    collisions.append(object)
                }

                objects.increment(for: object)
            }

            return (objects, collisions)
        }

        private static func parseHeapOutput(line: String) -> HeapOutput.Object? {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let components = trimmedLine.components(separatedBy: .whitespaces).filter { $0 != "" }

            guard !components.isEmpty else {
                return nil
            }

            let count = components[0]
            let bytes = components[1]
            let avg = components[2]
            let binary: String?
            let type: String?
            let className: String

            let remainingComponents = Array(components.dropFirst(3))

            if remainingComponents.count == 1 {
                binary = nil
                type = nil
                className = remainingComponents[0]
            } else if remainingComponents.count >= 3 {
                binary = remainingComponents.last
                type = remainingComponents[remainingComponents.count - 2]
                className = remainingComponents.dropLast(2).joined(separator: " ")
            } else {
                binary = nil
                type = nil
                className = remainingComponents.joined(separator: " ")
            }

            let object = HeapOutput.Object(
                count: count,
                bytes: bytes,
                avg: avg,
                className: className,
                type: type,
                binary: binary
            )

            return object
        }
    }
}

public enum HeapComparingResult: Equatable {
    public struct State: Equatable {
        public let addedObjects: [HeapOutput.Object: Int]
        public let missingObjects: [HeapOutput.Object: Int]
    }

    case equal, nonEqual(state: State)

    public var description: String {
        switch self {
        case .equal:
            return "equal"
        case .nonEqual(let state):
            var description = "\n"
            state.addedObjects.forEach { (key: HeapOutput.Object, value: Int) in
                description.append(
                    "[+] – \(key.className) (count – \(value), bytes – \(key.bytes), avg – \(key.avg), type – \(key.type), binary – \(key.binary)\n"
                )
            }
            state.missingObjects.forEach { (key: HeapOutput.Object, value: Int) in
                description.append(
                    "[-] – \(key.className) (count – \(value), bytes – \(key.bytes), avg – \(key.avg), type – \(key.type ?? "nil"), binary – \(key.binary)\n"
                )
            }

            return description
        }
    }
}
