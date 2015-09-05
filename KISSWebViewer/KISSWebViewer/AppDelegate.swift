//
//  AppDelegate.swift
//  KISSWebViewer
//
//  Created by Seth on 2015-08-22.
//  Copyright (c) 2015 DrabWeb. All rights reserved.
//

import Cocoa
import WebKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // A reference to the main window that holds the WebView
    @IBOutlet weak var window: NSWindow!
    
    // A reference to the window that has the helpers (URL field, reload ETC.)
    @IBOutlet weak var webViewHelpersWindow: NSWindow!
    
    // A reference to the WebView used in the app
    @IBOutlet weak var webView: WebView!
    
    // When the user presses the back button...
    @IBAction func backPressed(sender: AnyObject) {
        // Go back one page in the WebView
        webView.goBack();
    }
    
    // When the user presses the forward button...
    @IBAction func forwardPressed(sender: AnyObject) {
        // Go forward one page in the WebView
        webView.goForward();
    }
    
    // When the user presses the reload button...
    @IBAction func reloadPressed(sender: AnyObject) {
        // Relaod the page in the WebView
        webView.reload(self);
    }
    
    // A reference to the url field
    @IBOutlet weak var urlField: NSTextField!
    
    // When the user hits enter in the URL bar...
    @IBAction func urlFieldEntered(sender: AnyObject) {
        // Load the pages url that we entered
        webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: urlField.stringValue)!));
    }
    
    // A reference the the menu item that makes the window float
    @IBOutlet weak var floatMenuItem: NSMenuItem!
    
    // When the user presses the float menu item...
    @IBAction func floatMenuItemInteracted(sender: AnyObject) {
        // If the window level is 0 (The default, I think)...
        if(window.level == 0) {
            // Make the window level 250, so it floats
            window.level = 250;
            
            // Set the float menu item to have a check beside it
            floatMenuItem.state = 1;
        }
        // If the window level is 250(Floating)...
        else {
            // Set the level back to usual (0)
            window.level = 0;
            
            // Remove the check beside the float menu item
            floatMenuItem.state = 0;
        }
    }
    
    // A bool determining if the web view helpers window is hidden
    var helperWindowHidden : Bool = false;
    
    // A reference to the menu item that is used to toggle on and off the hiding of the webview helpers window
    @IBOutlet weak var hideHelperMenuItem: NSMenuItem!
    
    // When the user presses the hide webview helpers menu item...
    @IBAction func hideHelperMenuItemInteracted(sender: AnyObject) {
        // If the window is already hidden
        if(helperWindowHidden) {
            // Say its not hidden
            helperWindowHidden = false;
            
            // Remove the check by the appropriate menu item
            hideHelperMenuItem.state = 0;
            
            // Order front the helpers window
            webViewHelpersWindow.orderFrontRegardless();
        }
        // If the window is not hidden
        else {
            // Say its hidden
            helperWindowHidden = true;
            
            // Add the check by the appropriate menu item
            hideHelperMenuItem.state = 1;
            
            // Order out the helpers window
            webViewHelpersWindow.orderOut(self);
        }
    }
    
    // A reference to the menu item trhat locks the window aspect ratio
    @IBOutlet weak var lockAspectRatioMenuItem: NSMenuItem!
    
    // When the user presses the lock aspect ratio menu item...
    @IBAction func lockAspectRatioMenuItemInteracted(sender: AnyObject) {
        // Disable / hide the menu item
        lockAspectRatioMenuItem.hidden = true;
        
        // Lock the aspect ratio to the current window size
        window.aspectRatio = NSSize(width: window.frame.width, height: window.frame.height);
    }
    
    // A reference to the slider for the windows alpha value
    @IBOutlet weak var alphaSlider: NSSlider!
    
    // When the user changes teh alpha sliders value
    @IBAction func alphaSliderInteracted(sender: AnyObject) {
        // Set the main windows alpha value to the one we just entered
        window.alphaValue = CGFloat(alphaSlider.floatValue);
    }
    
    // The timer used for the refresh looper
    var reloadTimer = NSTimer();
    
    // A reference to the timer that controls the refresh loop
    @IBOutlet weak var refreshTimerTextField: NSTextField!
    
    // When the user enters a time for the refresh loop
    @IBAction func refreshTimerTextFieldInteracted(sender: AnyObject) {
        // Stop the timer
        reloadTimer.invalidate();
        
        // Start the refresh loop timer with the given time, linked to the refresh function
        reloadTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(refreshTimerTextField.integerValue), target:self, selector: Selector("refresh"), userInfo: nil, repeats:true);
    }
    
    // When the app finishes launching...
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Setup the windows we display to be visually appealing
        setupWindows();
        
        // Set the float menu item keybind to used the control key
        floatMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue);
        
        // And the f key
        floatMenuItem.keyEquivalent = "f";
        
        // Set the hide helper menu item keybind to used the control key
        hideHelperMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue);
        
        // And the h key
        hideHelperMenuItem.keyEquivalent = "h";
        
        // Set the lock aspect ratio menu item keybind to used the control key
        lockAspectRatioMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue);
        
        // And the r key
        lockAspectRatioMenuItem.keyEquivalent = "r";
        
        // Start the timer that sets the url field value to the currently loaded page
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("refreshURLBar"), userInfo: nil, repeats:true);
        
        // Set the webview so it closes when the parent window closes
        webView.shouldCloseWithWindow = true;
        
        // Disable webview background drawing
        webView.drawsBackground = false;
        
        // Load the homepage (DuckDuckGo in this case, but you can change it to whatever)
        webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.duckduckgo.com/")!));
        
        // Set the url field value to the homepage
        urlField.stringValue = webView.mainFrameURL;
    }
    
    // This sets the url bar value to teh currently loaded page
    func refreshURLBar() {
        // Set the url field value to the webview URL
        urlField.stringValue = webView.mainFrameURL;
    }
    
    // Refreshes the webview
    func refresh() {
        // Call the reload function
        webView.reload(self);
    }
    
    func setupWindows() {
        // Set the style mask
        window.styleMask = NSTitledWindowMask | NSFullSizeContentViewWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask;
        
        // Hide the background
        window.backgroundColor = NSColor.clearColor();
        window.opaque = true;
        
        // Hide the titlebar
        window.titlebarAppearsTransparent = true;
        
        // Hide the title
        window.titleVisibility = NSWindowTitleVisibility.Hidden;
        
        // Hide the close button
        var closeButton : NSButton = window.standardWindowButton(NSWindowButton.CloseButton)!;
        closeButton.hidden = true;
        
        // Hide the minimize button
        var minimizeButton : NSButton = window.standardWindowButton(NSWindowButton.MiniaturizeButton)!;
        minimizeButton.hidden = true;
        
        // Hide the zoom button
        var maximizeButton : NSButton = window.standardWindowButton(NSWindowButton.ZoomButton)!;
        maximizeButton.hidden = true;
        
        // Setup the helpers window
        
        // Set the style mask
        webViewHelpersWindow.styleMask = NSTitledWindowMask | NSFullSizeContentViewWindowMask | NSMiniaturizableWindowMask;
        
        // Hide the titlebar
        webViewHelpersWindow.titlebarAppearsTransparent = true;
        
        // Hide the title
        webViewHelpersWindow.titleVisibility = NSWindowTitleVisibility.Hidden;
        
        // Make the webview window focused
        window.makeKeyAndOrderFront(self);
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

