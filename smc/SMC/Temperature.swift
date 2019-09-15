//
//  Temperature.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

public struct Temperature {
    
    let celsius: Double
    let fahrenheit: Double
    let kelvin: Double
    
    static func fahrenheit(celsius: Double) -> Double {
        return (celsius * 1.8) + 32.0
    }
    
    static func kelvin(celsius: Double) -> Double {
        return celsius + 273.15
    }
    
    static func from(dictionary: [String: Any]) -> Temperature {
        return Temperature(celsius: dictionary["celsius"] as? Double ?? 0.0,
                           fahrenheit: dictionary["fahrenheit"] as? Double ?? 0.0,
                           kelvin: dictionary["kelvin"] as? Double ?? 0.0)
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["celsius"] = celsius
        dictionary["fahrenheit"] = fahrenheit
        dictionary["kelvin"] = kelvin
        
        return dictionary
    }
    
}
