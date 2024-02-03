//
//  NFCNDEFPayloadType+Extension.swift
//  NFCTagReaderDemo
//
//  Created by WadeGigatms on 2024/1/25.
//

import Foundation

extension NFCNDEFPayloadType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .T: return "T"
        case .U: return "U"
        }
    }
    
    public var fullDescription: String {
        switch self {
        case .T: return "Text"
        case .U: return "URI"
        }
    }
}
