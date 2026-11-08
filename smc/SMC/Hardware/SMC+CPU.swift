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
        guard let celsius: Double = validCelsius(key: sensor.key) else { return nil }
        return Temperature.from(celsius: celsius)
    }
    
    public func cpuTemperatureAverage() -> Temperature? {
        return averageTemperature(intelKeys: Sensor.CPU.allCases.map({ $0.key }), appleSiliconPrefixes: ["Tp", "Te"])
    }
    
    // MARK: - Helpers
    /// Apple silicon Macs have none of the Intel keys, so there the average uses every SMC key with one of the prefixes.
    func averageTemperature(intelKeys: [SensorKey], appleSiliconPrefixes: [String]) -> Temperature? {
        let sensorKeys: [SensorKey] = Device.Controller.isAppleSilicon
            ? allKeys.filter({ key in appleSiliconPrefixes.contains(where: { prefix in key.hasPrefix(prefix) }) })
            : intelKeys
        let celsiusTemperatures: [Double] = sensorKeys.compactMap({ validCelsius(key: $0) })
        
        guard !celsiusTemperatures.isEmpty else { return nil }
        return Temperature.from(celsius: celsiusTemperatures.total / Double(celsiusTemperatures.count))
    }
    
    /// - Returns: `nil` for a missing key and for a value outside 1 to 150 °C.
    func validCelsius(key: SensorKey) -> Double? {
        guard
            let celsius: Double = value(key: key),
            celsius > 1.0,
            celsius < 150.0
            else { return nil }
        return celsius
    }
    
}
