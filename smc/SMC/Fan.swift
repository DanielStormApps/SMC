//
//  Fan.swift
//  Fanny
//
//  Created by Daniel Storm on 9/15/19.
//  Copyright © 2019 Daniel Storm. All rights reserved.
//

import Foundation

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
