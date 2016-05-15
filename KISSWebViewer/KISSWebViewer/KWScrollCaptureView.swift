//
//  KWScrollCaptureView.swift
//  KISSWebViewer
//
//  Created by Seth on 2016-05-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KWScrollCaptureView: NSView {

    // Always accept first responder so we always get the scroll event
    override var acceptsFirstResponder : Bool {
        return true;
    }
    
    /// The object to perform scrollEventAction
    var scrollEventTarget : AnyObject? = nil;
    
    /// The selector to call when the user scrolls
    var scrollEventAction : Selector? = nil;
    
    override func scrollWheel(theEvent: NSEvent) {
        super.scrollWheel(theEvent);
        
        // If scrollEventTarget and scrollEventAction arent nil...
        if(scrollEventTarget != nil && scrollEventAction != nil) {
            // Perform the scroll event action
            scrollEventTarget!.performSelector(scrollEventAction!, withObject: theEvent);
        }
    }
}
