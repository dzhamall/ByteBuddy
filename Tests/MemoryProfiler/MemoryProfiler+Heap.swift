//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation
import Shared
import XCTest

@testable import ByteBuddy

final class MemoryProfilerHeapTests: XCTestCase {
    func testTakeHeapSnapshot() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutput, response: HTTPURLResponse())
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
                )
            ]
        )
    }

    func testCompareSnapshot() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutput, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let (result, collisions) = try await memoryProfiler.compareHeapSnapshots(isIncluded: { $0.binary == "ByteBuddyExample"})

        // Assert
        XCTAssertEqual(result, .equal)
        XCTAssertTrue(collisions.isEmpty)
    }
}
