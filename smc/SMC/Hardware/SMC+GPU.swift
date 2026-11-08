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
    public func gpuTemperature(sensor: Sensor.GPU) -> Temperature? {
        guard let celsius: Double = validCelsius(key: sensor.key) else { return nil }
        return Temperature.from(celsius: celsius)
    }
    
    public func gpuTemperatureAverage() -> Temperature? {
        return averageTemperature(intelKeys: Sensor.GPU.allCases.map({ $0.key }), appleSiliconPrefixes: ["Tg"])
    }
    
}
