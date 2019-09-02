//
//  SMC+GPU.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

extension SMC {
    
    // MARK: - GPU
    public func gpuTemperature(key: SensorKey = Sensor.GPU.proximity) -> Temperature? {
        guard let bytes = bytes(key: key) else { return nil }
        
        let celsius = Double(bytes.0 & 0x7F)
        
        return Temperature(celsius: celsius,
                           fahrenheit: Temperature.fahrenheit(celsius: celsius),
                           kelvin: Temperature.kelvin(celsius: celsius))
    }
    
}
