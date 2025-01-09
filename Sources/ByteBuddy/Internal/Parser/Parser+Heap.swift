//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

extension Parser {
    enum Heap {
        static func parseHeapOutput(
            _ data: Data,
            isIncluded: (HeapOutput) -> Bool
        ) throws -> [HeapEntity.Object: HeapEntity.Value] {
            guard let dataLines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines).dropFirst(36) else {
                throw Common.Error.parsingError(output: data)
            }

            var objects = [HeapEntity.Object: HeapEntity.Value]()

            dataLines.forEach { line in
                guard 
                    let (object, value) = parseHeapOutput(line: line),
                    let unwrappedObject = object,
                    let unwrappedValue = value
                else {
                    Logger.log("Parse heap output failure")
                    return
                }

                guard isIncluded(HeapOutput(object: unwrappedObject, value: unwrappedValue)) else {
                    return
                }

                objects.increment(for: unwrappedObject, value: unwrappedValue)
            }

            return objects
        }

        private static func parseHeapOutput(line: String) -> (HeapEntity.Object?, HeapEntity.Value?)? {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let components = trimmedLine.components(separatedBy: .whitespaces).filter { $0 != "" }

            guard !components.isEmpty else {
                return nil
            }

            let count = components[0]
            let bytes = components[1]
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

            let object = HeapEntity.Object(
                className: className,
                type: type,
                binary: binary
            )
            let value = HeapEntity.Value(
                count: count,
                bytes: bytes
            )

            return (object, value)
        }
    }
}

public enum HeapComparingResult: Equatable {
    public struct State: Equatable {
        public let addedObjects: [HeapOutput]
        public let missingObjects: [HeapOutput]
    }

    case equal, nonEqual(state: State)

    public var description: String {
        switch self {
        case .equal:
            return "equal"
        case .nonEqual(let state):
            var description = "\n"
            state.addedObjects.forEach {
                description.append(
                    "[+] – \($0.className) (count – \($0.count), bytes – \($0.bytes), avg – \($0.avg), type – \($0.type), binary – \($0.binary)\n"
                )
            }
            state.missingObjects.forEach {
                description.append(
                    "[-] – \($0.className) (count – \($0.count), bytes – \($0.bytes), avg – \($0.avg), type – \($0.type ?? "nil"), binary – \($0.binary)\n"
                )
            }

            return description
        }
    }
}
