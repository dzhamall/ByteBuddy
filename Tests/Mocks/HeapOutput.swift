//  ByteBuddyTests.swift
//  Created by dzhamall

import Foundation

let heapOutput: Data =
"""
Invalid connection: com.apple.coresymbolicationd
Process:         ByteBuddyExample [55156]
Path:            /Users/a.dzhamaldinov/Library/Developer/CoreSimulator/Devices/44E0B223-9987-4702-A7DC-D0E5DA36F481/data/Containers/Bundle/Application/23D5A14B-62E0-4900-8FDA-0C91C5E487A9/ByteBuddyExample.app/ByteBuddyExample
Load Address:    0x104a90000
Identifier:      ByteBuddyExample
Version:         ???
Code Type:       ARM64
Platform:        iOS Simulator
Parent Process:  launchd_sim [47663]

Date/Time:       (null)
Launch Time:     (null)
OS Version:      macOS 14.5 (23F79)
Report Version:  7
Analysis Tool:   /Library/Developer/CoreSimulator/Volumes/iOS_21C62/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 17.2.simruntime/Contents/Resources/RuntimeRoot/usr/bin/heap
Analysis Tool Version:  iOS Simulator 17.2 (21C62)

Physical footprint:         11.5M
Physical footprint (peak):  14.2M
Idle exit:                  untracked
----

Process 55156: 3 zones

All zones: 19103 nodes malloced - Sizes: 96KB[2] 18KB[1] 16KB[2] 10.5KB[1] 10KB[2] 9.5KB[2] 9KB[1] 8.5KB[2] 8KB[6] 7KB[1] 5.5KB[1] 5KB[7] 4.5KB[1] 4KB[21] 3KB[10] 2.5KB[65] 2KB[48] 1.5KB[19] 1KB[43] 1008[12] 976[3] 944[1] 896[2] 880[1] 832[1] 816[6] 800[3] 784[4] 768[11] 752[1] 736[1] 704[1] 688[3] 672[4] 656[7] 640[5] 624[2] 608[2] 592[9] 576[14] 544[6] 528[9] 512[106] 496[2] 480[7] 464[1] 448[15] 432[5] 416[2] 400[7] 384[14] 368[19] 352[7] 336[58] 320[1] 304[35] 288[19] 272[68] 256[179] 240[29] 224[254] 208[2490] 192[1409] 176[18] 160[110] 144[85] 128[542] 112[351] 96[253] 80[540] 64[1560] 48[1602] 32[8453] 16[519]

Found 965 ObjC classes
Found 62 Swift classes
Found 131 CFTypes
Type names for non-objects could be derived from allocation backtraces if the process used MallocStackLogging

-----------------------------------------------------------------------
All zones: 19103 nodes (2662832 bytes)

   COUNT      BYTES       AVG   CLASS_NAME                                        TYPE    BINARY
   =====      =====       ===   ==========                                        ====    ======
    4891     176576      36.1   CFString                                          ObjC    CoreFoundation
    4040     819264     202.8   CFString (Storage)                                C       CoreFoundation
    2591     664816     256.6   non-object
    2050      65600      32.0   Class.data (class_rw_t)                           C       libobjc.A.dylib
       2         64      32.0   NSHashTable.slice.acquisitionProps (struct NSSliceExternalAcquisitionProperties)  C       Foundation
       2         64      32.0   std::__shared_ptr_pointer<MCacheData*, std::shared_ptr<MCacheData>::__shared_ptr_default_delete<MCacheData, MCacheData>>  C++     libFontParser.dylib
       1        944     944.0   ViewController                                    Swift   ByteBuddyExample
       2        944     944.0   ExampleClass                                      Swift   ByteBuddyExample
       1        880     880.0   UIWindow                                          ObjC    UIKitCore
       1        240     240.0   _UIRemoteKeyboards                                ObjC    UIKitCore
       1        224     224.0   UIEventEnvironment                                ObjC    UIKitCore
       1        224     224.0   _CUIRawDataRendition                              ObjC    CoreUI
       1        224     224.0   _UIKeyWindowEvaluator                             ObjC    UIKitCore
       1        224     224.0   icu::Locale                                       C++     libicucore.A.dylib
       1        128     128.0   Swift._DictionaryStorage<Swift.String, Foundation._Locale>  Swift   libswiftCore.dylib
       1        128     128.0   Swift._DictionaryStorage<Swift.String, Foundation._NSSwiftLocale>  Swift   libswiftCore.dylib
""".data(using: .utf8)!

let heapOutputWithCollisions: Data =
"""
Invalid connection: com.apple.coresymbolicationd
Process:         ByteBuddyExample [55156]
Path:            /Users/a.dzhamaldinov/Library/Developer/CoreSimulator/Devices/44E0B223-9987-4702-A7DC-D0E5DA36F481/data/Containers/Bundle/Application/23D5A14B-62E0-4900-8FDA-0C91C5E487A9/ByteBuddyExample.app/ByteBuddyExample
Load Address:    0x104a90000
Identifier:      ByteBuddyExample
Version:         ???
Code Type:       ARM64
Platform:        iOS Simulator
Parent Process:  launchd_sim [47663]

Date/Time:       (null)
Launch Time:     (null)
OS Version:      macOS 14.5 (23F79)
Report Version:  7
Analysis Tool:   /Library/Developer/CoreSimulator/Volumes/iOS_21C62/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 17.2.simruntime/Contents/Resources/RuntimeRoot/usr/bin/heap
Analysis Tool Version:  iOS Simulator 17.2 (21C62)

Physical footprint:         11.5M
Physical footprint (peak):  14.2M
Idle exit:                  untracked
----

Process 55156: 3 zones

All zones: 19103 nodes malloced - Sizes: 96KB[2] 18KB[1] 16KB[2] 10.5KB[1] 10KB[2] 9.5KB[2] 9KB[1] 8.5KB[2] 8KB[6] 7KB[1] 5.5KB[1] 5KB[7] 4.5KB[1] 4KB[21] 3KB[10] 2.5KB[65] 2KB[48] 1.5KB[19] 1KB[43] 1008[12] 976[3] 944[1] 896[2] 880[1] 832[1] 816[6] 800[3] 784[4] 768[11] 752[1] 736[1] 704[1] 688[3] 672[4] 656[7] 640[5] 624[2] 608[2] 592[9] 576[14] 544[6] 528[9] 512[106] 496[2] 480[7] 464[1] 448[15] 432[5] 416[2] 400[7] 384[14] 368[19] 352[7] 336[58] 320[1] 304[35] 288[19] 272[68] 256[179] 240[29] 224[254] 208[2490] 192[1409] 176[18] 160[110] 144[85] 128[542] 112[351] 96[253] 80[540] 64[1560] 48[1602] 32[8453] 16[519]

Found 965 ObjC classes
Found 62 Swift classes
Found 131 CFTypes
Type names for non-objects could be derived from allocation backtraces if the process used MallocStackLogging

-----------------------------------------------------------------------
All zones: 19103 nodes (2662832 bytes)

   COUNT      BYTES       AVG   CLASS_NAME                                        TYPE    BINARY
   =====      =====       ===   ==========                                        ====    ======
    4891     176576      36.1   CFString                                          ObjC    CoreFoundation
    4040     819264     202.8   CFString (Storage)                                C       CoreFoundation
    2591     664816     256.6   non-object
    2050      65600      32.0   Class.data (class_rw_t)                           C       libobjc.A.dylib
       2         64      32.0   NSHashTable.slice.acquisitionProps (struct NSSliceExternalAcquisitionProperties)  C       Foundation
       2         64      32.0   std::__shared_ptr_pointer<MCacheData*, std::shared_ptr<MCacheData>::__shared_ptr_default_delete<MCacheData, MCacheData>>  C++     libFontParser.dylib
       1        944     944.0   ViewController                                    Swift   ByteBuddyExample
       1        880     880.0   UIWindow                                          ObjC    UIKitCore
       1        240     240.0   _UIRemoteKeyboards                                ObjC    UIKitCore
       1        224     224.0   UIEventEnvironment                                ObjC    UIKitCore
       1        224     224.0   _CUIRawDataRendition                              ObjC    CoreUI
       1        224     224.0   _UIKeyWindowEvaluator                             ObjC    UIKitCore
       1        224     224.0   icu::Locale                                       C++     libicucore.A.dylib
       1        128     128.0   Swift._DictionaryStorage<Swift.String, Foundation._Locale>  Swift   libswiftCore.dylib
       1        128     128.0   Swift._DictionaryStorage<Swift.String, Foundation._NSSwiftLocale>  Swift   libswiftCore.dylib
       1        944     944.0   ViewController                                    Swift   ByteBuddyExample
       2        944     944.0   ViewController                                    Swift   ByteBuddyExample
       2         32      32.0   Presenter                                         Swift   ByteBuddyExample
""".data(using: .utf8)!
