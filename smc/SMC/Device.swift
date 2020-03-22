//
//  Device.swift
//  smc
//
//  Created by Daniel Storm on 7/17/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation

public struct Device {
    
    struct Controller {
        
        static let isT2: Bool = {
            let system_profiler: Process = Process()
            let pipe: Pipe = Pipe()
            
            system_profiler.launchPath = "/usr/sbin/system_profiler"
            system_profiler.arguments = ["SPiBridgeDataType"]
            system_profiler.standardOutput = pipe
            
            system_profiler.launch()
            system_profiler.waitUntilExit()
            
            let data: Data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output: String? = String(data: data, encoding: .utf8)
            return output?.contains("Apple T2 Security Chip") == true ? true : false
        }()
        
    }
    
}
