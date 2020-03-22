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
            public static let core_01: SensorKey = "TC1C"
            public static let core_02: SensorKey = "TC2C"
            public static let core_03: SensorKey = "TC3C"
            public static let core_04: SensorKey = "TC4C"
            public static let core_05: SensorKey = "TC5C"
            public static let core_06: SensorKey = "TC6C"
            public static let core_07: SensorKey = "TC7C"
            public static let core_08: SensorKey = "TC8C"
            public static let die: SensorKey = "TC0F"
            public static let diode: SensorKey = "TC0D"
            public static let heatsink: SensorKey = "TC0H"
            public static let peci: SensorKey = "TCXC"
            public static let proximity: SensorKey = "TC0P"
            
            public static let all: [SensorKey] = [CPU.core_01,
                                                  CPU.core_02,
                                                  CPU.core_03,
                                                  CPU.core_04,
                                                  CPU.core_05,
                                                  CPU.core_06,
                                                  CPU.core_07,
                                                  CPU.core_08,
                                                  CPU.die,
                                                  CPU.diode,
                                                  CPU.heatsink,
                                                  CPU.peci,
                                                  CPU.proximity]
        }
        
        // MARK: - GPU
        public struct GPU {
            public static let diode: SensorKey = "TG0D"
            public static let heatsink: SensorKey = "TG0H"
            public static let peci: SensorKey = "TCGC"
            public static let proximity: SensorKey = "TG0P"
            
            public static let all: [SensorKey] = [GPU.diode,
                                                  GPU.heatsink,
                                                  GPU.peci,
                                                  GPU.proximity]
        }
        
    }
    
}
