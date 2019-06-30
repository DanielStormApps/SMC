//
//  SMC.swift
//  smc
//
//  Created by Daniel Storm on 6/30/19.
//  Copyright © 2019 Daniel Storm. All rights reserved.
//

import Foundation
import IOKit

class SMC {
    
    private static var connection: io_connect_t = 0
    
    // MARK: Init
    static let shared = SMC()
    private init() {
        openConnection()
    }
    
    // MARK: - Connection Lifecycle
    private func openConnection() {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleSMC"))
        assert(IOServiceOpen(service, mach_task_self_, 0, &SMC.connection) == kIOReturnSuccess, "Unable to start SMC")
        IOObjectRelease(service)
        
        let numberOfFans = bytes(key: "FNum")!.0
        print("numberOfFans: \(numberOfFans)")
        
        let cpuTemperature = bytes(key: "TC0P")!.0 & 0x7F
        print("cpuTemperature: \(cpuTemperature)")
        
    }
    
    private func closeConnection() {
        IOServiceClose(SMC.connection)
    }
    
    // MARK: - SMC
    func bytes(key: String) -> SMCBytes? {
        guard let smcKey = key.smcKey() else { return nil }
        let outputDataSize = dataSize(smcKey: smcKey)
        let outputBytes = bytes(smcKey: smcKey, dataSize: outputDataSize)
        return outputBytes
    }
    
    // MARK: - SMC Helpers
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
