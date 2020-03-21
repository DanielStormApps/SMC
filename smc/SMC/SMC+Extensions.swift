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

extension Collection where Element: Numeric {
    
    public var total: Element {
        return reduce(0, +)
    }
    
}
