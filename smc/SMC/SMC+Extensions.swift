//
//  SMC+Extensions.swift
//  smc
//
//  Created by Daniel Storm on 6/30/19.
//  Copyright © 2019 Daniel Storm. All rights reserved.
//

import Foundation

extension String {
    
    func smcKey() -> UInt32? {
        guard self.count == 4 else { return nil }
        
        let value = self.utf8.reduce(0) { sumOfBits, character in
            return sumOfBits << 8 | UInt32(character)
        }
        
        return value
    }

}
