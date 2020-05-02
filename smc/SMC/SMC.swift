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
    public static let shared: SMC = SMC()
    private init() {
        openConnection()
    }
    
    // MARK: - Connection Lifecycle
    private func openConnection() {
        let service: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleSMC"))
        guard IOServiceOpen(service, mach_task_self_, 0, &SMC.connection) == kIOReturnSuccess else { fatalError("Unable to start SMC") }
        IOObjectRelease(service)
    }
    
    private func closeConnection() {
        IOServiceClose(SMC.connection)
    }
    
    // MARK: - SMC
    public func bytes(key: String) -> SMCBytes? {
        guard let smcKey: UInt32 = key.smcKey() else { return nil }
        let outputDataSize: IOByteCount = dataSize(smcKey: smcKey)
        let outputBytes: SMCBytes = bytes(smcKey: smcKey, dataSize: outputDataSize)
        return outputBytes
    }
    
    // MARK: - Helpers
    private func dataSize(smcKey: UInt32) -> IOByteCount {
        var inputStructure: SMCStructure = SMCStructure()
        var outputStructure: SMCStructure = SMCStructure()
        
        let inputStructureSize: Int = MemoryLayout<SMCStructure>.stride
        var outputStructureSize: Int = MemoryLayout<SMCStructure>.stride
        
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
        var inputStructure: SMCStructure = SMCStructure()
        var outputStructure: SMCStructure = SMCStructure()
        
        let inputStructureSize: Int = MemoryLayout<SMCStructure>.stride
        var outputStructureSize: Int = MemoryLayout<SMCStructure>.stride
        
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
        print()
        print("------------------")
        print("System Information")
        print("------------------")
        
        // Fans
        print()
        let fans: [Fan] = SMC.shared.fans()
        for fan in fans {
            print("Fan: \(fan)")
        }
        
        // CPU
        print()
        print("CPU (°C)")
        for sensor in Sensor.CPU.allCases {
            let cpuTemperature: Temperature? = SMC.shared.cpuTemperature(sensor: sensor)
            print("\(sensor.title) [\(sensor.key)]: \(cpuTemperature?.celsius ?? 0.0)")
        }
        
        // GPU
        print()
        print("GPU (°C)")
        for sensor in Sensor.GPU.allCases {
            let gpuTemperature: Temperature? = SMC.shared.gpuTemperature(sensor: sensor)
            print("\(sensor.title) [\(sensor.key)]: \(gpuTemperature?.celsius ?? 0.0)")
        }
        
        print()
        print("------------------")
        print()
    }
    #endif
    
}
