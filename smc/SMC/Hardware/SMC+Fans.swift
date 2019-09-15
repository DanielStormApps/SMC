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
    public struct Fan {
        let identifier: Int
        let currentRPM: Int?
        let minimumRPM: Int?
        let maximumRPM: Int?
        let targetRPM: Int?
        
        static func from(dictionary: [String: Any]) -> Fan {
            return Fan(identifier: dictionary["identifier"] as? Int ?? 0,
                       currentRPM: dictionary["currentRPM"] as? Int,
                       minimumRPM: dictionary["minimumRPM"] as? Int,
                       maximumRPM: dictionary["maximumRPM"] as? Int,
                       targetRPM: dictionary["targetRPM"] as? Int)
        }
        
        func dictionaryRepresentation() -> [String: Any] {
            var dictionary: [String: Any] = [:]
            
            dictionary["identifier"] = identifier
            dictionary["currentRPM"] = currentRPM
            dictionary["minimumRPM"] = minimumRPM
            dictionary["maximumRPM"] = maximumRPM
            dictionary["targetRPM"] = targetRPM
            
            return dictionary
        }
        
    }
    
    public func fans() -> [Fan] {
        guard let numberOfFans = numberOfFans() else { return [] }
        var fans: [Fan] = []
        for i in 0..<numberOfFans { fans.append(fan(at: i)) }
        return fans
    }
    
    public func numberOfFans() -> Int? {
        guard let bytes = bytes(key: "FNum") else { return nil }
        return Int(bytes.0)
    }
    
    private func fan(at index: Int) -> Fan {
        return Fan(identifier: index,
                   currentRPM: fanCurrentRPM(for: index),
                   minimumRPM: fanMinimumRPM(for: index),
                   maximumRPM: fanMaximumRPM(for: index),
                   targetRPM: fanTargetRPM(for: index))
    }
    
    private func fanCurrentRPM(for identifier: Int) -> Int? {
        guard let bytes = bytes(key: "F\(identifier)Ac") else { return nil }
        return integer(for: bytes)
    }
    
    private func fanMinimumRPM(for identifier: Int) -> Int? {
        guard let bytes = bytes(key: "F\(identifier)Mn") else { return nil }
        return integer(for: bytes)
    }
    
    private func fanMaximumRPM(for identifier: Int) -> Int? {
        guard let bytes = bytes(key: "F\(identifier)Mx") else { return nil }
        return integer(for: bytes)
    }
    
    private func fanTargetRPM(for identifier: Int) -> Int? {
        guard let bytes = bytes(key: "F\(identifier)Tg") else { return nil }
        return integer(for: bytes)
    }
    
    // MARK: - Helpers
    private func integer(for bytes: SMCBytes) -> Int {
        // Devices that have a T2 security chip use an FLT data type
        if Device.Controller.isT2 {
            var value: Float = 0.0
            memcpy(&value, [bytes.0, bytes.1, bytes.2, bytes.3], 4)
            return Int(value)
        }
        else {
            return (Int(bytes.0) << 6) + (Int(bytes.1) >> 2)
        }
    }
    
}
