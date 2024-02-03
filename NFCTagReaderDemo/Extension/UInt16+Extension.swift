//
//  UInt16+Extension.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import Foundation

extension UInt16 {
    func convertToByteArray(_ value: UInt16) -> [UInt8] {
        let highByte = UInt8((value >> 8) & 0xFF)
        let lowByte = UInt8(value & 0xFF)
        return [highByte, lowByte]
    }
}
