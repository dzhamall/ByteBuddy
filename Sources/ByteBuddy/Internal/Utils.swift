//  ByteBuddy.swift
//  Created by dzhamall

import Foundation

struct SnapshotsSource {
    let dir: URL
    let url: URL

    private init(dir: URL, url: URL) {
        self.dir = dir
        self.url = url
    }

    static func getFileURL(_ file: StaticString) -> SnapshotsSource {
        let name = URL(fileURLWithPath: "\(file)", isDirectory: false).deletingPathExtension().lastPathComponent
        let sourceURL = URL(fileURLWithPath: "\(file)").deletingLastPathComponent()
        let snapshotsDirectory = sourceURL.appendingPathComponent("MemorySnapshots")
        let snapshotURL = snapshotsDirectory.appendingPathComponent("\(name)_HeapSnapshot.json")

        return SnapshotsSource(dir: snapshotsDirectory, url: snapshotURL)
    }
}
