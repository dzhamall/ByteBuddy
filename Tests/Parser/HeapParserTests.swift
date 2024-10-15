//  ByteBuddyTests.swift
//  Created by dzhamall

import XCTest
import Shared
@testable import ByteBuddy

final class HeapParserTests: XCTestCase {

    func testParseHeapOutputCorrectlyWithFilter() throws {
        // Act
        let heap: HeapOutput = try Parser.Heap.parseHeapOutput(
            heapOutput,
            isIncluded: { $0.binary == "ByteBuddyExample" }
        )

        // Assert
        XCTAssertEqual(
            heap,
            HeapOutput(objects: [
                HeapOutput.Object(
                    count: 1,
                    bytes: 944,
                    avg: 944,
                    className: "ViewController",
                    type: "Swift",
                    binary: "ByteBuddyExample"
                )
            ])
        )
    }

    func testParseHeapOutputCorrectlyWithoutFilter() throws {
        let expectatedHeap = HeapOutput(objects: [
            HeapOutput.Object(count: 4891, bytes: 176576, avg: 36.1, className: "CFString", type: "ObjC", binary: "CoreFoundation"),
            HeapOutput.Object(count: 4040, bytes: 819264, avg: 202.8, className: "CFString (Storage)", type: "C", binary: "CoreFoundation"),
            HeapOutput.Object(count: 2591, bytes: 664816, avg: 256.6, className: "non-object", type: nil, binary: nil),
            HeapOutput.Object(count: 2050, bytes: 65600, avg: 32.0, className: "Class.data (class_rw_t)", type: "C", binary: "libobjc.A.dylib"),
            HeapOutput.Object(count: 2, bytes: 64, avg: 32.0, className: "NSHashTable.slice.acquisitionProps (struct NSSliceExternalAcquisitionProperties)", type: "C", binary: "Foundation"),
            HeapOutput.Object(count: 2, bytes: 64, avg: 32.0, className: "std::__shared_ptr_pointer<MCacheData*, std::shared_ptr<MCacheData>::__shared_ptr_default_delete<MCacheData, MCacheData>>", type: "C++", binary: "libFontParser.dylib"),
            HeapOutput.Object(count: 1, bytes: 944, avg: 944.0, className: "ViewController", type: "Swift", binary: "ByteBuddyExample"),
            HeapOutput.Object(count: 1, bytes: 880, avg: 880.0, className: "UIWindow", type: "ObjC", binary: "UIKitCore"),
            HeapOutput.Object(count: 1, bytes: 240, avg: 240.0, className: "_UIRemoteKeyboards", type: "ObjC", binary: "UIKitCore"),
            HeapOutput.Object(count: 1, bytes: 224, avg: 224.0, className: "UIEventEnvironment", type: "ObjC", binary: "UIKitCore"),
            HeapOutput.Object(count: 1, bytes: 224, avg: 224.0, className: "_CUIRawDataRendition", type: "ObjC", binary: "CoreUI"),
            HeapOutput.Object(count: 1, bytes: 224, avg: 224.0, className: "_UIKeyWindowEvaluator", type: "ObjC", binary: "UIKitCore"),
            HeapOutput.Object(count: 1, bytes: 224, avg: 224.0, className: "icu::Locale", type: "C++", binary: "libicucore.A.dylib"),
            HeapOutput.Object(count: 1, bytes: 128, avg: 128.0, className: "Swift._DictionaryStorage<Swift.String, Foundation._Locale>", type: "Swift", binary: "libswiftCore.dylib"),
            HeapOutput.Object(count: 1, bytes: 128, avg: 128.0, className: "Swift._DictionaryStorage<Swift.String, Foundation._NSSwiftLocale>", type: "Swift", binary: "libswiftCore.dylib")
        ])

        // Act
        let heap: HeapOutput = try Parser.Heap.parseHeapOutput(heapOutput, isIncluded: { _ in true })

        // Assert
        XCTAssertEqual(heap.objects.count, expectatedHeap.objects.count)
        XCTAssertEqual(heap, expectatedHeap)
    }

}
