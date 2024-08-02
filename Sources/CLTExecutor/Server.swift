//  Server.swift
//  Created by dzhamall

import Foundation
import Shared
import Swifter

final class Server {
    private let server: HttpServer

    init() {
        server = HttpServer()
    }

    deinit {
        stop()
    }

    func start(on port: UInt16) throws {
        try server.start(port)
        Logger.log("Server listening on port \(port)...")
        RunLoop.main.run()
    }

    func stop() {
        Logger.log("Stop the server")
        server.stop()
    }

    func handleRequest(_ completion: @escaping (String, String) -> Result<String, Shared.ByteBuddy.Error>) {
        server.GET[Shared.ByteBuddy.urlPath] = { request in
            guard let command = request.headerValue(for: .cmd) else {
                return .badRequest(.text("Exectuble command is nil"))
            }

            guard let pid = request.headerValue(for: .pid) else {
                return .badRequest(.text("Process identifier is nil"))
            }

            let result = completion(command, pid)
            switch result {
            case let .success(output):
                return .ok(.text(output))

            case let .failure(error):
                return .badRequest(.text(error.localizedDescription))
            }
        }
    }
}

// MARK: - HttpRequest + headerValue

private extension HttpRequest {
    func headerValue(for key: HeaderFieldKey) -> String? {
        self.headers[key.rawValue]
    }
}
