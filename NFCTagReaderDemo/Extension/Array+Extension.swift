//
//  Array+Extension.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import Foundation

extension Array {
    public func seperate(by size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
