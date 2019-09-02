//
//  SMC+Sensor.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

public typealias SensorKey = String

extension SMC {

    // MARK: - Sensor
    public struct Sensor {
        
        // MARK: - CPU
        public struct CPU {
            public static let proximity: SensorKey = "TC0P"
        }
        
        // MARK: - GPU
        public struct GPU {
            public static let proximity: SensorKey = "TG0P"
        }
        
    }
    
}
