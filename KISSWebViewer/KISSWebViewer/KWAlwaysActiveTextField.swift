//
//  KWAlwaysActiveTextField.swift
//  KISSWebViewer
//
//  Created by Seth on 2016-05-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KWAlwaysActiveTextField: NSTextField {

    // Override acceptsFirstResponder so it is always in the active graphical state
    override var acceptsFirstResponder : Bool {
        return true;
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}
