//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation
import Shared
import XCTest

@testable import ByteBuddy

final class MemoryProfilerCompareHeapWithoutEqualSnapshotsTests: XCTestCase {
    func testTakeHeapWithoutEqualSnapshots() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutput, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let heapOutput = try await memoryProfiler.takeHeapSnapshot(isIncluded: { $0.binary == "ByteBuddyExample"} )

        // Assert
        XCTAssertEqual(
            heapOutput.sorted(by: { $0.className < $1.className }),
            [
                HeapOutput(className: "ExampleClass", type: "Swift", binary: "ByteBuddyExample", count: 2, bytes: 944, avg: 472),
                HeapOutput(className: "ViewController", type: "Swift", binary: "ByteBuddyExample", count: 1, bytes: 944, avg: 944)
            ]
        )
    }

    func testCompareHeapWithoutEqualSnapshots() async throws {
        // Arrange
        let pid = "byteBuddyId"
        let networkSessionMock = NetworkSessionMock(data: heapOutput, response: HTTPURLResponse())
        let memoryProfiler = MemoryProfiler(env: Environment(port: 8080, pid: pid), networkSession: networkSessionMock)

        // Act
        let result = try await memoryProfiler.compareHeapSnapshots(isIncluded: { $0.binary == "ByteBuddyExample"})

        // Assert
        guard case .nonEqual(let state) = result else {
            XCTFail("Incorrect condition")
            return
        }

        XCTAssertEqual(
            state.addedObjects,
            [
                HeapOutput(className: "ExampleClass", type: "Swift", binary: "ByteBuddyExample", count: 1, bytes: 472, avg: 472)
            ]
        )
        XCTAssertEqual(
            state.missingObjects.sorted(by: { $0.className < $1.className }),
            [
                HeapOutput(className: "Presenter", type: "Swift", binary: "ByteBuddyExample", count: 2, bytes: 944, avg: 472),
                HeapOutput(className: "ViewController", type: "Swift", binary: "ByteBuddyExample", count: 2, bytes: 944, avg: 472)
            ]
        )
    }
}
