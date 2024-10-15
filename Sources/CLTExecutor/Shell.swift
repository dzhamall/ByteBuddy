//  Shell.swift
//  Created by dzhamall

import Foundation
import Shared

enum Shell {
    struct Output {
        let data: String?
        let status: Int32
    }

    static func execute(_ cmd: String) -> Output {
        let task = Process()

        task.launchPath = "/bin/bash"
        task.arguments = ["-c", cmd]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()
        return Output(data: output, status: task.terminationStatus)
    }
}
