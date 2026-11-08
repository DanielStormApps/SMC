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
    private static var cachedKeys: [String] = []
    
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
        return read(key: key)?.bytes
    }
    
    /// Reads a key and decodes it by the data type the SMC reports for it.
    /// - Returns: `nil` when the key does not exist, its type is not flt, fpe2, sp78, ui8, ui16 or ui32,
    ///   or its size does not match its type.
    public func value(key: String) -> Double? {
        guard let reading: (dataType: String, dataSize: UInt32, bytes: SMCBytes) = read(key: key) else { return nil }
        let valueBytes: [UInt8] = withUnsafeBytes(of: reading.bytes) { Array($0.prefix(Int(reading.dataSize))) }
        
        switch reading.dataType {
        case "flt ":
            guard valueBytes.count == 4 else { return nil }
            let bits: UInt32 = UInt32(valueBytes[0]) | UInt32(valueBytes[1]) << 8 | UInt32(valueBytes[2]) << 16 | UInt32(valueBytes[3]) << 24
            return Double(Float(bitPattern: bits))
        case "fpe2":
            guard valueBytes.count == 2 else { return nil }
            return Double(UInt16(valueBytes[0]) << 8 | UInt16(valueBytes[1])) / 4.0
        case "sp78":
            guard valueBytes.count == 2 else { return nil }
            return Double(Int16(bitPattern: UInt16(valueBytes[0]) << 8 | UInt16(valueBytes[1]))) / 256.0
        case "ui8 ", "ui16", "ui32":
            return Double(valueBytes.reduce(UInt64(0)) { $0 << 8 | UInt64($1) })
        default:
            return nil
        }
    }
    
    /// All key names the SMC reports. An empty result is not cached, so the next call reads again.
    var allKeys: [String] {
        if SMC.cachedKeys.isEmpty { SMC.cachedKeys = readAllKeys() }
        return SMC.cachedKeys
    }
    
    // MARK: - Helpers
    private func read(key: String) -> (dataType: String, dataSize: UInt32, bytes: SMCBytes)? {
        guard let smcKey: UInt32 = key.smcKey() else { return nil }
        
        var infoInput: SMCStructure = SMCStructure()
        infoInput.key = smcKey
        infoInput.data8 = SMCStructure.Selector.kSMCGetKeyInfo.rawValue
        guard let info: SMCStructure = call(infoInput) else { return nil }
        
        var readInput: SMCStructure = SMCStructure()
        readInput.key = smcKey
        readInput.keyInfo.dataSize = info.keyInfo.dataSize
        readInput.data8 = SMCStructure.Selector.kSMCReadKey.rawValue
        guard let output: SMCStructure = call(readInput) else { return nil }
        
        return (info.keyInfo.dataType.smcKeyString(), info.keyInfo.dataSize, output.bytes)
    }
    
    private func readAllKeys() -> [String] {
        guard
            let count: Double = value(key: "#KEY"),
            count > 0,
            count < 100_000
            else { return [] }
        
        return (0..<UInt32(count)).compactMap({ index in
            var inputStructure: SMCStructure = SMCStructure()
            inputStructure.data8 = SMCStructure.Selector.kSMCGetKeyFromIndex.rawValue
            inputStructure.data32 = index
            return call(inputStructure)?.key.smcKeyString()
        })
    }
    
    /// - Returns: `nil` when the call fails or the SMC reports an error, such as an unknown key.
    private func call(_ input: SMCStructure) -> SMCStructure? {
        var inputStructure: SMCStructure = input
        var outputStructure: SMCStructure = SMCStructure()
        
        let inputStructureSize: Int = MemoryLayout<SMCStructure>.stride
        var outputStructureSize: Int = MemoryLayout<SMCStructure>.stride
        
        let result: kern_return_t = IOConnectCallStructMethod(SMC.connection,
                                                              UInt32(SMCStructure.Selector.kSMCHandleYPCEvent.rawValue),
                                                              &inputStructure,
                                                              inputStructureSize,
                                                              &outputStructure,
                                                              &outputStructureSize)
        
        guard
            result == kIOReturnSuccess,
            outputStructure.result == SMCStructure.Result.kSMCSuccess.rawValue
            else { return nil }
        
        return outputStructure
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
