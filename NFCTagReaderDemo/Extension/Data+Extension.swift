//
//  Data+Extension.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import Foundation

extension Data {
    func toLongHexString() -> String {
        return !self.isEmpty ? self.map { String(format: "0x%02hX", $0) }.joined(separator: " ") : ""
    }
    
    func toShortHexString() -> String {
        return !self.isEmpty ? self.map { String(format: "%02hX", $0) }.joined() : ""
    }
    
    func toFormattedHexString() -> String {
        let hexString = map { String(format: "0x%02X", $0) }.joined(separator: " ")
        let chunks = hexString.chunked()
        return chunks.joined(separator: "\n")
    }
    
    func toString() -> String {
        if let uhf8String = String(data: self, encoding: .utf8) {
            return uhf8String
        } else if let ascii = String(data: self, encoding: .ascii) {
            return ascii
        } else {
            return ""
        }
    }
}
