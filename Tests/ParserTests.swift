//  ParserTests.swift
//  Created by dzhamall

import XCTest
@testable import ByteBuddy

final class ParserTests: XCTestCase {

    // MARK: - Leaks

    func testParseLeaksOutputCorrectly() throws {
        // Act
        let leaks = try Parser.parseLeaksOutput(leaksOutput)

        // Assert
        XCTAssertEqual(leaks.count, 2)
        XCTAssertEqual(
            leaks.message,
            """
            leaks Report Version: 4.0
            Process 81862: 16462 nodes malloced for 2106 KB
            Process 81862: 2 leaks for 64 total leaked bytes.

                2 (64 bytes) ROOT CYCLE: <A 0x600000224fa0> [32]
                   1 (32 bytes) b --> ROOT CYCLE: <B 0x6000002255c0> [32]
                      __strong a --> CYCLE BACK TO <A 0x600000224fa0> [32]
                  15 (1.53K) ROOT LEAK: <NSURL 0x600001e80fc0> [96]
                     13 (1.34K) <_FileCache 0x1319b9e80> [320]
                        8 (736 bytes) <CFDictionary 0x600002e351c0> [64]
                           6 (608 bytes) <CFDictionary (Value Storage) 0x600002e231c0> [64]
                              3 (480 bytes) <NSURL 0x600001e80960> [96]
                                 1 (320 bytes) <_FileCache 0x1319c00e0> [320]
                                 1 (64 bytes) _clients --> <CFString 0x600002e37300> [64]
            """
        )
    }

    func testParseEmptyLeaksOutputCorrectly() throws {
        // Act
        let leaks = try Parser.parseLeaksOutput(emptyLeaksOutput)

        // Arrange
        XCTAssertEqual(leaks.count, 0)
        XCTAssertEqual(
            leaks.message,
            """
            leaks Report Version: 4.0
            Process 53732: 31594 nodes malloced for 3372 KB
            Process 53732: 0 leaks for 0 total leaked bytes.
            """
        )
    }
}

private extension ParserTests {
    var leaksOutput: Data {
    """
    Invalid connection: com.apple.coresymbolicationd
    Process:         ByteBuddyExample [81862]
    Path:            /Users/a.dzhamaldinov/Library/Developer/XCTestDevices/595D62D7-7641-454B-9A4B-762F76492DB0/data/Containers/Bundle/Application/F22FA24A-BEAF-4505-976D-D0BC4E5B8E78/ByteBuddyExample.app/ByteBuddyExample
    Load Address:    0x1020a0000
    Identifier:      ByteBuddyExample
    Version:         ???
    Code Type:       ARM64
    Platform:        iOS Simulator
    Parent Process:  launchd_sim [57452]

    Date/Time:       (null)
    Launch Time:     (null)
    OS Version:      macOS 14.5 (23F79)
    Report Version:  7
    Analysis Tool:   /Library/Developer/CoreSimulator/Volumes/iOS_21C62/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 17.2.simruntime/Contents/Resources/RuntimeRoot/usr/bin/leaks
    Analysis Tool Version:  iOS Simulator 17.2 (21C62)

    Physical footprint:         11.0M
    Physical footprint (peak):  13.7M
    Idle exit:                  untracked
    ----

    leaks Report Version: 4.0
    Process 81862: 16462 nodes malloced for 2106 KB
    Process 81862: 2 leaks for 64 total leaked bytes.

        2 (64 bytes) ROOT CYCLE: <A 0x600000224fa0> [32]
           1 (32 bytes) b --> ROOT CYCLE: <B 0x6000002255c0> [32]
              __strong a --> CYCLE BACK TO <A 0x600000224fa0> [32]
          15 (1.53K) ROOT LEAK: <NSURL 0x600001e80fc0> [96]
             13 (1.34K) <_FileCache 0x1319b9e80> [320]
                8 (736 bytes) <CFDictionary 0x600002e351c0> [64]
                   6 (608 bytes) <CFDictionary (Value Storage) 0x600002e231c0> [64]
                      3 (480 bytes) <NSURL 0x600001e80960> [96]
                         1 (320 bytes) <_FileCache 0x1319c00e0> [320]
                         1 (64 bytes) _clients --> <CFString 0x600002e37300> [64]
    """.data(using: .utf8)!
    }

    var emptyLeaksOutput: Data {
    """
    Invalid connection: com.apple.coresymbolicationd
    Process:         ByteBuddyExample [53732]
    Path:            /Users/a.dzhamaldinov/Library/Developer/CoreSimulator/Devices/44E0B223-9987-4702-A7DC-D0E5DA36F481/data/Containers/Bundle/Application/79F24CDE-28EC-4039-971E-AF2763CA1874/ByteBuddyExample.app/ByteBuddyExample
    Load Address:    0x102494000
    Identifier:      ByteBuddyExample
    Version:         ???
    Code Type:       ARM64
    Platform:        iOS Simulator
    Parent Process:  debugserver [53733]

    Date/Time:       (null)
    Launch Time:     (null)
    OS Version:      macOS 14.5 (23F79)
    Report Version:  7
    Analysis Tool:   /Library/Developer/CoreSimulator/Volumes/iOS_21C62/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 17.2.simruntime/Contents/Resources/RuntimeRoot/usr/bin/leaks
    Analysis Tool Version:  iOS Simulator 17.2 (21C62)

    Physical footprint:         27.5M
    Physical footprint (peak):  27.6M
    Idle exit:                  untracked
    ----

    leaks Report Version: 4.0
    Process 53732: 31594 nodes malloced for 3372 KB
    Process 53732: 0 leaks for 0 total leaked bytes.
    """.data(using: .utf8)!
    }
}
