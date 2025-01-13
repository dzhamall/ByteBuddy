//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation
import Shared
import XCTest

@testable import ByteBuddy

final class MemoryProfilerCompareHeapWithEqualSnapshotsTests: XCTestCase {
    func testTakeHeapWithEqualSnapshots() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutputWithCollisions, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let heapOutput = try await memoryProfiler
            .takeHeapSnapshot(isIncluded: { $0.binary == "ByteBuddyExample"} )
            .sorted { $0.className > $1.className }

        // Assert
        XCTAssertEqual(
            heapOutput,
            [
                HeapOutput(
                    className: "ViewController",
                    type: "Swift",
                    binary: "ByteBuddyExample",
                    count: 4,
                    bytes: 2832,
                    avg: 708
                ),
                HeapOutput(
                    className: "Presenter",
                    type: "Swift",
                    binary: "ByteBuddyExample",
                    count: 2,
                    bytes: 32,
                    avg: 16
                )
            ]
        )
    }

    func testCompareHeapWithEqualSnapshots() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutputWithCollisions, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let result = try await memoryProfiler.compareHeapSnapshots(
            source: TestsUtils.getSnapshotURL(),
            isIncluded: {
                $0.binary == "ByteBuddyExample"
            }
        )

        // Assert
        XCTAssertEqual(result, .equal, result.description)
    }
}
