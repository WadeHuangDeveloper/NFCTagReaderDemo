//
//  NFCNDEFStatus+Extension.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import Foundation
import CoreNFC

extension NFCNDEFStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notSupported: return "Not Supported"
        case .readOnly: return "Read Only"
        case .readWrite: return "Read/Write"
        @unknown default: return "Unknown"
        }
    }
}
