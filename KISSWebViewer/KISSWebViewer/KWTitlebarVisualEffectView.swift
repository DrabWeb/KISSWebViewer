//
//  KWTitlebarVisualEffectView.swift
//  KISSWebViewer
//
//  Created by Seth on 2016-05-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KWTitlebarVisualEffectView: NSVisualEffectView {

    override func mouseDragged(theEvent: NSEvent) {
        if #available(OSX 10.11, *) {
            // Perform a window drag with the drag event
            window!.performWindowDragWithEvent(theEvent);
        } else {
            // Move the window with the mouse's delta
            window!.setFrameOrigin(NSPoint(x: window!.frame.origin.x + theEvent.deltaX, y: window!.frame.origin.y - theEvent.deltaY));
        };
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}
