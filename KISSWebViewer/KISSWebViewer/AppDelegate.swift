//
//  AppDelegate.swift
//  KISSWebViewer
//
//  Created by Seth on 2016-05-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// View/Select URL Field (⌘L)
    @IBOutlet weak var menuItemSelectUrlField: NSMenuItem!

    /// View/Toggle Titlebar (⌘⌥T)
    @IBOutlet weak var menuItemToggleTitlebar: NSMenuItem!
    
    /// View/Go Back (⌘[)
    @IBOutlet weak var menuItemGoBack: NSMenuItem!

    /// View/Go Forward (⌘])
    @IBOutlet weak var menuItemGoForward: NSMenuItem!
    
    /// View/Reload (⌘R)
    @IBOutlet weak var menuItemReload: NSMenuItem!
    
    /// Window/Toggle Picture in Picture Mode (⌘⌥P)
    @IBOutlet weak var menuItemTogglePictureInPictureMode: NSMenuItem!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

