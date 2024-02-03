//
//  String+Extension.swift
//  NFCTagReaderDemo
//
//  Created by Huei-Der Huang on 2024/1/24.
//

import Foundation

extension String {
    func chunked() -> [String] {
        var chunks = [String]()
        var index = startIndex
        var line = 1
        
        while index < endIndex {
            let endIndex = self.index(index, offsetBy: 20, limitedBy: endIndex) ?? endIndex
            let chunk = String(self[index..<endIndex])
            chunks.append(chunk)
            index = endIndex
            line += 1
        }
        
        return chunks
    }
}
