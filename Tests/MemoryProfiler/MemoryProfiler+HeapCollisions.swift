//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation
import ByteBuddy
import Shared
import XCTest

final class MemoryProfilerHeapCollisionsTests: XCTestCase {
    func testTakeHeapSnapshotWithCollisions() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutputWithCollisions, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let heapOutput = try await memoryProfiler.takeHeapSnapshot(isIncluded: { $0.binary == "ByteBuddyExample"} )

        // Assert
        XCTAssertEqual(
            heapOutput.objects,
            [
                HeapOutput.Object(
                    count: 1,
                    bytes: 944,
                    avg: 944,
                    className: "ViewController",
                    type: "Swift",
                    binary: "ByteBuddyExample"
                ),
                HeapOutput.Object(
                    count: 1,
                    bytes: 944,
                    avg: 944,
                    className: "ViewController",
                    type: "Swift",
                    binary: "ByteBuddyExample"
                ),
                HeapOutput.Object(
                    count: 2,
                    bytes: 944,
                    avg: 944,
                    className: "ViewController",
                    type: "Swift",
                    binary: "ByteBuddyExample"
                )
            ]
        )
    }

    func testCompareSnapshotWithCollisions() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutputWithCollisions, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let (result, collisions) = try await memoryProfiler.compareHeapSnapshots(isIncluded: { $0.binary == "ByteBuddyExample"})

        // Arrange
        XCTAssertEqual(result, .equal, result.description)
        XCTAssertEqual(
            collisions,
            [
                HeapOutput.Object(count: 1, bytes: 944, avg: 944, className: "ViewController", type: "Swift", binary: "ByteBuddyExample"),
                HeapOutput.Object(count: 2, bytes: 944, avg: 944, className: "ViewController", type: "Swift", binary: "ByteBuddyExample")
            ]
        )
    }
}
