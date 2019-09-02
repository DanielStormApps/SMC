//
//  AppDelegate.swift
//  smc
//
//  Created by Daniel Storm on 6/30/19.
//  Copyright © 2019 Daniel Storm (github.com/DanielStormApps).
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        SMC.shared.printSystemInformation()
    }

}
