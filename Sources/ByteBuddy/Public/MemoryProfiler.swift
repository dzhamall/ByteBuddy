//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

typealias InternalError = Common.Error

public final class MemoryProfiler {
    private let env: Environment
    private let networkSession: NetworkSession

    public init(env: Environment) {
        self.env = env
        self.networkSession = URLSession(configuration: .default)
    }

    internal init(env: Environment, networkSession: NetworkSession) {
        self.env = env
        self.networkSession = networkSession
    }
}

// MARK: - Leaks

public extension MemoryProfiler {
    func detectLeaks() async throws -> LeaksOutput {
        let data = try await execute(.leaks)
        let leaksOutput = try Parser.Leaks.parseLeaksOutput(data)
        return leaksOutput
    }
}

// MARK: - Heap

public extension MemoryProfiler {
    func takeHeapSnapshot(isIncluded: ((HeapOutput) -> Bool)? = nil) async throws -> [HeapOutput] {
        let data = try await execute(.heap)
        let heapObjects = try Parser.Heap.parseHeapOutput(
            data,
            isIncluded: isIncluded ?? { _ in true }
        )

        return heapObjects.map { HeapOutput(object: $0, value: $1) }
    }

    func save(heapOutput: [HeapOutput], to file: StaticString = #file) throws {
        try save(heapOutput, to: file)
    }

    func compareHeapSnapshots(
        isIncluded: ((HeapOutput) -> Bool)? = nil,
        file: StaticString = #file
    ) async throws -> HeapComparingResult {
        let data = try await execute(.heap)
        var diff = [HeapEntity.Object: HeapEntity.Value]()
        var heapObjects = try Parser.Heap.parseHeapOutput(
            data,
            isIncluded: isIncluded ?? { _ in true }
        )
        let heapSnapshot = try loadSnapshot(from: file)

        heapSnapshot.forEach {
            let object = HeapEntity.Object(className: $0.className, type: $0.type, binary: $0.binary)
            let value = HeapEntity.Value(count: $0.count, bytes: $0.bytes)

            if heapObjects.keys.contains(object) {
                let remainingResult = heapObjects.decrement(for: object, value: value)
                guard let (excessObject, excessValue) = remainingResult else {
                    return
                }
                diff.increment(for: excessObject, value: excessValue)
            } else {
                diff.increment(for: object, value: value)
            }
        }

        guard diff.isEmpty, heapObjects.isEmpty else {
            return (
                .nonEqual(
                    state: HeapComparingResult.State(
                        addedObjects: heapObjects.map { HeapOutput(object: $0, value: $1)},
                        missingObjects: diff.map { HeapOutput(object: $0, value: $1)}
                    )
                )
            )
        }

        return (.equal)
    }
}

// MARK: - Private

private extension MemoryProfiler {
    func execute(_ command: Command) async throws -> Data {
        let request = try command.asURLRequest(env: env)
        let (data, response) = try await networkSession.loadData(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw InternalError.noHttpResponse
        }

        guard response.statusCode == 200 else {
            throw InternalError.unexpectedHttpStatusCode(response)
        }

        return data
    }

    func save(_ output: [HeapOutput], to file: StaticString) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let jsonData = try encoder.encode(output)
        let snapshotsSource = SnapshotsSource.getFileURL(file)

        try FileManager.default.createDirectory(at: snapshotsSource.dir, withIntermediateDirectories: true)
        try jsonData.write(to: snapshotsSource.url)
    }

    func loadSnapshot(from file: StaticString) throws -> [HeapOutput] {
        let snapshotsSource = SnapshotsSource.getFileURL(file)
        let jsonData = try Data(contentsOf: snapshotsSource.url)
        let heapOutput = try JSONDecoder().decode([HeapOutput].self, from: jsonData)
        return heapOutput
    }
}
