//
//  SMC+CPU.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

extension SMC {
    
    // MARK: - CPU
    public func cpuTemperature(sensor: Sensor.CPU) -> Temperature? {
        guard let bytes: SMCBytes = bytes(key: sensor.key) else { return nil }
        
        let celsius: Double = Double(bytes.0 & 0x7F)
        
        return Temperature(celsius: celsius,
                           fahrenheit: Temperature.fahrenheit(celsius: celsius),
                           kelvin: Temperature.kelvin(celsius: celsius))
    }
    
    public func cpuTemperatureAverage() -> Temperature? {
        let celsiusTemperatures: [Double] = Sensor.CPU.allCases.compactMap({
            guard let bytes: SMCBytes = bytes(key: $0.key) else { return nil }
            let celsius: Double = Double(bytes.0 & 0x7F)
            return celsius > 1.0 ? celsius : nil
        })
        
        guard !celsiusTemperatures.isEmpty else { return nil }
        let averageCelsius: Double = celsiusTemperatures.total / Double(celsiusTemperatures.count)
        
        return Temperature(celsius: averageCelsius,
                           fahrenheit: Temperature.fahrenheit(celsius: averageCelsius),
                           kelvin: Temperature.kelvin(celsius: averageCelsius))
    }
    
}
