//  MemoryProfiler.swift
//  Created by dzhamall

import Foundation
import Shared

public final class MemoryProfiler {
    private let session: URLSession
    private let env: Environment

    public init(env: Environment) {
        self.session = URLSession(configuration: .default)
        self.env = env
    }

    public func detectLeaks(completion: @escaping (Result<Void, ByteBuddy.Error>) -> Void) {
        do {
            try execute(.leaks) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    let result = self.prepareLeaksOutput(data)
                    completion(result)

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error as ByteBuddy.Error {
            completion(.failure(error))
        } catch {
            Logger.log(error.localizedDescription, level: .error)
            completion(.failure(.unknown))
        }
    }
}

// MARK: - Private

private extension MemoryProfiler {
    func execute(_ command: Command, completion: @escaping (Result<Data, ByteBuddy.Error>) -> Void) throws {
        let request = try command.asURLRequest(env: env)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serviceError(error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noHttpResponse))
                return
            }

            guard response.statusCode == 200 else {
                completion(.failure(.unexpectedHttpStatusCode(response)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData(response)))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }

    func prepareLeaksOutput(_ data: Data) -> Result<Void, ByteBuddy.Error> {
        do {
            let leaks = try Parser.parseLeaksOutput(data)
            return leaks.count == 0 ? .success(()) : .failure(.leaksFoud(output: leaks))
        } catch let error as ByteBuddy.Error {
            return .failure(error)
        } catch {
            Logger.log(error.localizedDescription, level: .error)
            return .failure(.unknown)
        }
    }
}
