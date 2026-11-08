//
//  Device.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

public struct Device {
    
    struct Controller {
        
        /// True on an Apple silicon Mac, also when this process runs under Rosetta.
        static let isAppleSilicon: Bool = {
            var value: Int32 = 0
            var size: Int = MemoryLayout<Int32>.size
            return sysctlbyname("hw.optional.arm64", &value, &size, nil, 0) == 0 && value == 1
        }()
        
    }
    
}
