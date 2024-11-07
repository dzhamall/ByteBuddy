# 📟 ByteBuddy

[![build](https://github.com/dzhamall/ByteBuddy/actions/workflows/tests.yml/badge.svg)](https://github.com/dzhamall/ByteBuddy/actions/workflows/tests.yml)
[![release](https://github.com/dzhamall/ByteBuddy/actions/workflows/release.yml/badge.svg)](https://github.com/dzhamall/ByteBuddy/actions/workflows/release.yml)
[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/dzhamall/ByteBuddy/blob/master/LICENSE)  

Swift library that automates the operation of a command-line tool to find memory issues using ui and unit tests.

## ⚙️ Quick Source Code Tour
ByteBuddy is divided into two parts. 
1. `ByteBuddy` – is a Swift library. It provides an interface for command line tools for memory profiling such as leaks and heap. To execute these commands, the library connects to `CLTExecutor` over a local network.
2. `CLTExecutor` – is a Swift executable library. It starts the local server using [Swifter](https://github.com/httpswift/swifter) and listens for requests from `ByteBuddy` (client lib) and executes memory profiling commands.

In OS X, the leaks command-line tool searches the virtual memory space of a process for buffers that were allocated by malloc but are no longer referenced. For each leaked buffer it finds, leaks displays the following information:
- the address of the leaked memory
- the size of the leak (in bytes)
- the name of the object

The heap command-line tool displays a snapshot of the memory allocated by the malloc library and located in the address space of a specified process.

For more information, please refer to the following sources:
- [ManagingMemory](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/ManagingMemory/ManagingMemory.html#//apple_ref/doc/uid/10000160-SW1)
- [iOS Memory Deep Dive](https://developer.apple.com/videos/play/wwdc2018/416)

## 🚀 Getting Started

> **Important:** Use `ByteBuddy` only to access the library in your test target

First, you need to run `CLTExecutor` before each test run. To do this, you can use pre and post actions of your test target:
###### Pre-actions
```sh
#!/bin/bash
killall CLTExecutor || true
set -e
${BUILD_ROOT}/../../SourcePackages/checkouts/ByteBuddy/bin/CLTExecutor start-server --port 8080 > /dev/null 2>&1 &
```
###### Post-actions
```sh
#!/bin/bash
set -e
killall CLTExecutor
```

The default ports used by the server is 8080.
If you need to use another port you need to provide it via the --port flag when calling CLTExecutor and adjust the client port accordingly when setting up your test in code.й

Then you just need to use an instance of the Memory Profiler class and use its api to detect memory leaks, take snapshots of the heap and compare them during testing. 
For example:
```swift
func testSomeCode() {
  /// test some flow

  addTeardownBlock {
    let env = Environment(port: 8080, pid: app.pid)
    let profiler = MemoryProfiler(env: env)

    let leaksOutput = try await profiler.detectLeaks()
    XCTAssertEqual(leaksOutput.count, 0, leaksOutput.message)
  }
}
```
If leaks are found, the test will drop with an informative log:
```
Process 12540: 44820 nodes malloced for 5669 KB
Process 12540: 2 leaks for 64 total leaked bytes.

    2 (64 bytes) ROOT CYCLE: <Class 0x600000260040> [32]
       1 (32 bytes) closure + 8 --> ROOT CYCLE: <Swift closure context 0x600000260080> [32]
          __strong  --> CYCLE BACK TO <MyClass 0x600000260040> [32]
```
The same goes for heap snapshots:
```swift
func testSomeCode() {
  /// test some flow

  addTeardownBlock {
    let env = Environment(port: 8080, pid: app.pid)
    let profiler = MemoryProfiler(env: env)

    let heapOutput = try await memoryProfiler.takeHeapSnapshot()
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
}
```
