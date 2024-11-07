//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

typealias InternalError = ByteBuddy.Error

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
    func takeHeapSnapshot(isIncluded: ((HeapOutput.Object) -> Bool)? = nil) async throws -> HeapOutput {
        let data = try await execute(.heap)
        let heapOutput: HeapOutput = try Parser.Heap.parseHeapOutput(
            data,
            isIncluded: isIncluded ?? { _ in true }
        )

        return heapOutput
    }

    func save(heapOutput: HeapOutput, to file: StaticString = #file) throws {
        try save(heapOutput, to: file)
    }

    func compareHeapSnapshots(
        isIncluded: ((HeapOutput.Object) -> Bool)? = nil,
        file: StaticString = #file
    ) async throws -> (HeapComparingResult, [HeapOutput.Object]) {
        let data = try await execute(.heap)
        var diff = [HeapOutput.Object: Int]()
        var (heapObjects, collisions) = try Parser.Heap.parseHeapOutput(data, isIncluded: isIncluded ?? { _ in true })
        let heapSnapshot = try loadSnapshot(from: file)

        heapSnapshot.objects.forEach { object in
            if heapObjects.keys.contains(object) {
                heapObjects.decrement(for: object)
            } else {
                diff.increment(for: object)
            }
        }

        guard diff.isEmpty, heapObjects.isEmpty else {
            return (
                .nonEqual(state: HeapComparingResult.State(addedObjects: heapObjects, missingObjects: diff)),
                collisions
            )
        }

        return (.equal, collisions)
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

    func save(_ output: HeapOutput, to file: StaticString) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let jsonData = try encoder.encode(output)
        let snapshotsSource = SnapshotsSource.getFileURL(file)

        try FileManager.default.createDirectory(at: snapshotsSource.dir, withIntermediateDirectories: true)
        try jsonData.write(to: snapshotsSource.url)
    }

    func loadSnapshot(from file: StaticString) throws -> HeapOutput {
        let snapshotsSource = SnapshotsSource.getFileURL(file)
        let jsonData = try Data(contentsOf: snapshotsSource.url)
        let heapOutput = try JSONDecoder().decode(HeapOutput.self, from: jsonData)
        return heapOutput
    }
}
