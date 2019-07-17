//
//  Temperature.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

struct Temperature {
    
    let celsius: Double
    let fahrenheit: Double
    let kelvin: Double
    
    static func fahrenheit(celsius: Double) -> Double {
        return (celsius * 1.8) + 32.0
    }
    
    static func kelvin(celsius: Double) -> Double {
        return celsius + 273.15
    }
}
