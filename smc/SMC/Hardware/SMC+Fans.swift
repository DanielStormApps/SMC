//
//  SMC+Fans.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

extension SMC {
    
    // MARK: - Fans
    public func fans() -> [Fan] {
        guard let numberOfFans: Int = numberOfFans() else { return [] }
        var fans: [Fan] = []
        for i in 0..<numberOfFans { fans.append(fan(at: i)) }
        return fans
    }
    
    public func numberOfFans() -> Int? {
        guard
            let count: Double = value(key: "FNum"),
            count >= 0,
            count <= 16
            else { return nil }
        return Int(count)
    }
    
    private func fan(at index: Int) -> Fan {
        return Fan(identifier: index,
                   currentRPM: fanCurrentRPM(for: index),
                   minimumRPM: fanMinimumRPM(for: index),
                   maximumRPM: fanMaximumRPM(for: index),
                   targetRPM: fanTargetRPM(for: index))
    }
    
    private func fanCurrentRPM(for identifier: Int) -> Int? {
        return rpm(key: "F\(identifier)Ac")
    }
    
    private func fanMinimumRPM(for identifier: Int) -> Int? {
        return rpm(key: "F\(identifier)Mn")
    }
    
    private func fanMaximumRPM(for identifier: Int) -> Int? {
        return rpm(key: "F\(identifier)Mx")
    }
    
    private func fanTargetRPM(for identifier: Int) -> Int? {
        return rpm(key: "F\(identifier)Tg")
    }
    
    // MARK: - Helpers
    private func rpm(key: String) -> Int? {
        guard
            let rpm: Double = value(key: key),
            rpm >= 0,
            rpm < 100_000
            else { return nil }
        return Int(rpm)
    }
    
}
