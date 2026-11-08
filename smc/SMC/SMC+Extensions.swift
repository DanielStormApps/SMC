//
//  SMC+Extensions.swift
//  smc
//
//  Created by Daniel Storm on 6/30/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

extension String {
    
    public func smcKey() -> UInt32? {
        guard self.count == 4 else { return nil }
        
        let value: UInt32 = self.utf8.reduce(0) { sumOfBits, character in
            return sumOfBits << 8 | UInt32(character)
        }
        
        return value
    }

}

extension UInt32 {
    
    /// The four-character name of an SMC key or data type, such as "F0Ac" or "flt ".
    public func smcKeyString() -> String {
        let characters: [UInt8] = [UInt8(self >> 24 & 0xFF), UInt8(self >> 16 & 0xFF), UInt8(self >> 8 & 0xFF), UInt8(self & 0xFF)]
        return String(decoding: characters, as: UTF8.self)
    }
    
}

extension Collection where Element: Numeric {
    
    public var total: Element {
        return reduce(0, +)
    }
    
}
