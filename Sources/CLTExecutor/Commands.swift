//  Commands.swift
//  Created by dzhamall

import ArgumentParser
import Shared
import Foundation

struct ByteBuddy: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "ByteBuddy",
        abstract: "Swift client-server tool to find memory issues.",
        subcommands: [
            StartServer.self
        ]
    )
}

struct StartServer: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Run the server that will be called by your test code to run the command-line tool"
    )

    @Option(name: .shortAndLong, help: "The port to listen on")
    var port: UInt16 = 8080

    mutating func run() throws {
        let server = Server()

        server.handleRequest { cmd, pid in
            runCommand("\(cmd) \(pid)")
        }

        try server.start(on: port)
    }
}

private func runCommand(_ cmd: String) -> Result<String, Shared.ByteBuddy.Error> {
    Logger.log("Run command: \(cmd) ⚙️")

    let output = Shell.execute(cmd)
    guard output.status == 0 || output.status == 1 else {
        return .failure(.shellError(output: output.data))
    }

    let successMessage = "shell command executed  ✅"
    Logger.log("\(successMessage)")
    return .success(output.data ?? successMessage)
}
