//
//  SMC.swift
//  smc
//
//  Created by Daniel Storm on 6/30/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Foundation
import IOKit

public class SMC {
    
    private static var connection: io_connect_t = 0
    
    // MARK: - Init
    public static let shared = SMC()
    private init() {
        openConnection()
    }
    
    // MARK: - Connection Lifecycle
    private func openConnection() {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleSMC"))
        assert(IOServiceOpen(service, mach_task_self_, 0, &SMC.connection) == kIOReturnSuccess, "Unable to start SMC")
        IOObjectRelease(service)
    }
    
    private func closeConnection() {
        IOServiceClose(SMC.connection)
    }
    
    // MARK: - SMC
    public func bytes(key: String) -> SMCBytes? {
        guard let smcKey = key.smcKey() else { return nil }
        let outputDataSize = dataSize(smcKey: smcKey)
        let outputBytes = bytes(smcKey: smcKey, dataSize: outputDataSize)
        return outputBytes
    }
    
    // MARK: - Helpers
    private func dataSize(smcKey: UInt32) -> IOByteCount {
        var inputStructure = SMCStructure()
        var outputStructure = SMCStructure()
        
        let inputStructureSize = MemoryLayout<SMCStructure>.stride
        var outputStructureSize = MemoryLayout<SMCStructure>.stride
        
        inputStructure.key = smcKey
        inputStructure.data8 = 9
        
        let _ = IOConnectCallStructMethod(SMC.connection,
                                          2,
                                          &inputStructure,
                                          inputStructureSize,
                                          &outputStructure,
                                          &outputStructureSize)
        
        return outputStructure.keyInfo.dataSize
    }
    
    private func bytes(smcKey: UInt32, dataSize: UInt32) -> SMCBytes {
        var inputStructure = SMCStructure()
        var outputStructure = SMCStructure()
        
        let inputStructureSize = MemoryLayout<SMCStructure>.stride
        var outputStructureSize = MemoryLayout<SMCStructure>.stride
        
        inputStructure.key = smcKey
        inputStructure.keyInfo.dataSize = dataSize
        inputStructure.data8 = 5
        
        let _ = IOConnectCallStructMethod(SMC.connection,
                                          2,
                                          &inputStructure,
                                          inputStructureSize,
                                          &outputStructure,
                                          &outputStructureSize)
        
        return outputStructure.bytes
    }
    
    // MARK: - Deinit
    deinit {
        closeConnection()
    }
    
}

extension SMC {
    
    #if DEBUG
    /// - Note: Only available in `DEBUG` environment.
    public func printSystemInformation() {
        print("------------------")
        print("System Information")
        print("------------------")
        
        // Fans
        print()
        let fans = SMC.shared.fans()
        for fan in fans {
            print("Fan: \(fan)")
        }
        
        // CPU
        print()
        let cpuTemperature = SMC.shared.cpuTemperature()
        print("CPU C: \(String(describing: cpuTemperature?.celsius))")
        print("CPU F: \(String(describing: cpuTemperature?.fahrenheit))")
        print("CPU K: \(String(describing: cpuTemperature?.kelvin))")
        
        // GPU
        print()
        let gpuTemperature = SMC.shared.gpuTemperature()
        print("GPU C: \(String(describing: gpuTemperature?.celsius))")
        print("GPU F: \(String(describing: gpuTemperature?.fahrenheit))")
        print("GPU K: \(String(describing: gpuTemperature?.kelvin))")
        
        print()
        print("------------------")
    }
    #endif
}
