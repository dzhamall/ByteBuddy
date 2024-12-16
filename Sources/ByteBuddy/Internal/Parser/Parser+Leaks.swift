//  ByteBuddy.swift
//  Created by dzhamall

import Foundation
import Shared

extension Parser {
    enum Leaks {
        static func parseLeaksOutput(_ data: Data) throws -> LeaksOutput {
            guard let strData = String(data: data, encoding: .utf8) else {
                throw Common.Error.parsingError(output: data)
            }
            
            let pattern = "(leaks Report Version:\\s*\\d+\\.\\d+.*)"
            let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
            if
                let match = regex.firstMatch(in: strData, options: [], range: NSRange(location: 0, length: strData.count)),
                let range = Range(match.range(at: 1), in: strData)
            {
                let extractedText = String(strData[range])
                let numberOfLeaks = getNumberOfLeaks(from: extractedText)
                return LeaksOutput(count: numberOfLeaks, message: extractedText)
            }
            throw Common.Error.parsingError(output: data)
        }
        
        private static func getNumberOfLeaks(from message: String) -> Int {
            let pattern: String = ".*(\\d+) leaks for (\\d+) total leaked bytes.*"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                if let match = regex.firstMatch(in: message, options: [], range: NSRange(message.startIndex..., in: message)) {
                    if let dRange = Range(match.range(at: 1), in: message), let dValue = Int(message[dRange]) {
                        return dValue
                    }
                }
            }
            
            return 0
        }
    }
}
