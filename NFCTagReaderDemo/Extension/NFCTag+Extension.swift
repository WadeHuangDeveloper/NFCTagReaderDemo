//
//  NFCTag+Extension.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import Foundation
import CoreNFC

extension NFCTag: CustomStringConvertible {
    public var description: String {
        switch self {
            case .feliCa(_): return "FeliCa"
            case .iso15693(_): return "ISO15693"
            case .iso7816(_): return "ISO7816"
            case let .miFare(tag):
                switch tag.mifareFamily {
                    case .ultralight : return "MIFARE Ultralight"
                    case .plus: return "MIFARE Plus"
                    case .desfire: return "MIFARE DESFire"
                    case .unknown: return "ISO14443 Type A"
                    @unknown default: return "Unknown"
                }
            @unknown default: return "Unknown"
        }
    }
}
