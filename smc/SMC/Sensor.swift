//
//  Sensor.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

public typealias SensorKey = String

private protocol GenericSensor: CaseIterable {
    init?(key: SensorKey)
    var key: SensorKey { get }
    var index: Int { get }
    var title: String { get }
}

// MARK: - Sensor
public enum Sensor {
    
    // MARK: - CPU
    public enum CPU: String, GenericSensor {
        case core_01 = "TC1C"
        case core_02 = "TC2C"
        case core_03 = "TC3C"
        case core_04 = "TC4C"
        case core_05 = "TC5C"
        case core_06 = "TC6C"
        case core_07 = "TC7C"
        case core_08 = "TC8C"
        case die = "TC0F"
        case diode = "TC0D"
        case heatsink = "TC0H"
        case peci = "TCXC"
        case proximity = "TC0P"
        
        public init?(key: SensorKey) {
            self.init(rawValue: key)
        }
        
        public var key: SensorKey {
            return self.rawValue
        }
        
        public var index: Int {
            return CPU.allCases.firstIndex(of: self)!
        }
        
        public var title: String {
            switch self {
            case .core_01: return "Core 1"
            case .core_02: return "Core 2"
            case .core_03: return "Core 3"
            case .core_04: return "Core 4"
            case .core_05: return "Core 5"
            case .core_06: return "Core 6"
            case .core_07: return "Core 7"
            case .core_08: return "Core 8"
            case .die: return "Die"
            case .diode: return "Diode"
            case .heatsink: return "Heatsink"
            case .peci: return "PECI"
            case .proximity: return "Proximity"
            }
        }
    }
    
    // MARK: - GPU
    public enum GPU: String, GenericSensor {
        case diode = "TG0D"
        case heatsink = "TG0H"
        case peci = "TCGC"
        case proximity = "TG0P"
        
        public init?(key: SensorKey) {
            self.init(rawValue: key)
        }
        
        public var key: SensorKey {
            return self.rawValue
        }
        
        public var index: Int {
            return GPU.allCases.firstIndex(of: self)!
        }
        
        public var title: String {
            switch self {
            case .diode: return "Diode"
            case .heatsink: return "Heatsink"
            case .peci: return "PECI"
            case .proximity: return "Proximity"
            }
        }
    }
    
}
