//  ByteBuddyTests.swift
//  Created by dzhamall

import XCTest
import Shared
@testable import ByteBuddy

final class HeapParserTests: XCTestCase {

    func testParseHeapOutputCorrectlyWithFilter() throws {
        // Act
        let heap: [HeapEntity.Object : HeapEntity.Value] = try Parser.Heap.parseHeapOutput(
            heapOutput,
            isIncluded: { $0.binary == "ByteBuddyExample" }
        )

        // Assert
        XCTAssertEqual(
            heap,
            [
                HeapEntity.Object(className: "ViewController", type: "Swift", binary: "ByteBuddyExample"): HeapEntity.Value(count: 1, bytes: 944),
                HeapEntity.Object(className: "ExampleClass", type: "Swift", binary: "ByteBuddyExample"): HeapEntity.Value(count: 2, bytes: 944)
            ]
        )
    }

    func testParseHeapOutputCorrectlyWithoutFilter() throws {
        let output = [
            HeapOutput(className: "CFString", type: "ObjC", binary: "CoreFoundation", count: 4891, bytes: 176576, avg: 36),
            HeapOutput(className: "CFString (Storage)", type: "C", binary: "CoreFoundation", count: 4040, bytes: 819264, avg: 202),
            HeapOutput(className: "non-object", type: nil, binary: nil, count: 2591, bytes: 664816, avg: 256),
            HeapOutput(className: "Class.data (class_rw_t)", type: "C", binary: "libobjc.A.dylib", count: 2050, bytes: 65600, avg: 32),
            HeapOutput(className: "NSHashTable.slice.acquisitionProps (struct NSSliceExternalAcquisitionProperties)", type: "C", binary: "Foundation", count: 2, bytes: 64, avg: 32),
            HeapOutput(className: "std::__shared_ptr_pointer<MCacheData*, std::shared_ptr<MCacheData>::__shared_ptr_default_delete<MCacheData, MCacheData>>", type: "C++", binary: "libFontParser.dylib", count: 2, bytes: 64, avg: 32),
            HeapOutput(className: "ViewController", type: "Swift", binary: "ByteBuddyExample", count: 1, bytes: 944, avg: 944),
            HeapOutput(className: "ExampleClass", type: "Swift", binary: "ByteBuddyExample", count: 2, bytes: 944, avg: 472),
            HeapOutput(className: "UIWindow", type: "ObjC", binary: "UIKitCore", count: 1, bytes: 880, avg: 880),
            HeapOutput(className: "_UIRemoteKeyboards", type: "ObjC", binary: "UIKitCore", count: 1, bytes: 240, avg: 240),
            HeapOutput(className: "UIEventEnvironment", type: "ObjC", binary: "UIKitCore", count: 1, bytes: 224, avg: 224),
            HeapOutput(className: "_CUIRawDataRendition", type: "ObjC", binary: "CoreUI", count: 1, bytes: 224, avg: 224),
            HeapOutput(className: "_UIKeyWindowEvaluator", type: "ObjC", binary: "UIKitCore", count: 1, bytes: 224, avg: 224),
            HeapOutput(className: "icu::Locale", type: "C++", binary: "libicucore.A.dylib", count: 1, bytes: 224, avg: 224),
            HeapOutput(className: "Swift._DictionaryStorage<Swift.String, Foundation._Locale>", type: "Swift", binary: "libswiftCore.dylib", count: 1, bytes: 128, avg: 128),
            HeapOutput(className: "Swift._DictionaryStorage<Swift.String, Foundation._NSSwiftLocale>", type: "Swift", binary: "libswiftCore.dylib", count: 1, bytes: 128, avg: 128)
        ]
        let expectatedHeap = output.reduce(into: [HeapEntity.Object: HeapEntity.Value]()) {
            $0[HeapEntity.Object(className: $1.className, type: $1.type, binary: $1.binary)] = HeapEntity.Value(count: $1.count, bytes: $1.bytes)
        }

        // Act
        let heap = try Parser.Heap.parseHeapOutput(heapOutput, isIncluded: { _ in true })

        // Assert
        XCTAssertEqual(heap, expectatedHeap)
    }
}
