//
//  ViewController.swift
//  KISSWebViewer
//
//  Created by Seth on 2016-05-15.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa
import WebKit

import Cocoa

class ViewController: NSViewController, NSWindowDelegate, WebFrameLoadDelegate {
    
    /// The main window of this view controller
    var window : NSWindow = NSWindow();
    
    /// The web view for this window
    @IBOutlet var webView: WebView!
    
    /// The visual effect view for the titlebar of the window
    @IBOutlet var titlebarVisualEffectView: NSVisualEffectView!
    
    // The segmented control for letting the user press the back/forward buttons
    @IBOutlet weak var titlebarNavigationSegmentedControl : NSSegmentedControl!
    
    /// When the user presses titlebarNavigationSegmentedControl...
    @IBAction func titlebarNavigationSegmentedControlPressed(sender: NSSegmentedControl) {
        // If the user pressed the back button...
        if(sender.selectedSegment == 0) {
            // Go back in the web view
            webView.goBack();
        }
        // If the user pressed the forward button...
        else if(sender.selectedSegment == 1) {
            // Go forward in the web view
            webView.goForward();
        }
    }
    
    /// The button in the titlebar for reloading the page
    @IBOutlet weak var titlebarRefreshButton: NSButton!
    
    /// When the user presses titlebarRefreshButton...
    @IBAction func titlebarRefreshButtonPressed(sender: NSButton) {
        // Refresh the web view
        webView.reload(self);
    }
    
    /// The text field in the titlebar for opening URLs and displaying the current URL
    @IBOutlet var titlebarUrlTextField: KWAlwaysActiveTextField!
    
    /// When the user enters text into titlebarUrlTextField...
    @IBAction func titlebarUrlTextFieldEntered(sender: KWAlwaysActiveTextField) {
        /// The entered string as an NSURL, used to check if the entered URL is valid
        var enteredStringAsUrl = NSURL(string: sender.stringValue);
        
        // If we entered a valid URL...
        if(enteredStringAsUrl != nil && enteredStringAsUrl?.scheme != "" && enteredStringAsUrl?.host != nil) {
            // Open the entered URL
            openUrl(sender.stringValue);
        }
        // If we didnt enter a valid URL...
        else {
            // Set entered URL to the entered URL with https:// in the front
            enteredStringAsUrl = NSURL(string: "https://" + sender.stringValue);
            
            // If the URL is now valid...
            if(enteredStringAsUrl != nil && enteredStringAsUrl?.scheme != "" && enteredStringAsUrl?.host != nil) {
                // Open the entered URL with https:// in the front
                openUrl("https://" + sender.stringValue);
            }
            // If the URL is still invalid...
            else {
                // Set entered URL to the entered URL with http:// in the front
                enteredStringAsUrl = NSURL(string: "http://" + sender.stringValue);
                
                // If the URL is now valid...
                if(enteredStringAsUrl != nil && enteredStringAsUrl?.scheme != "" && enteredStringAsUrl?.host != nil) {
                    // Open the entered URL with http:// in the front
                    openUrl("http://" + sender.stringValue);
                }
                // If the URL is still invalid...
                else {
                    // Search for the entered string
                    openUrl("https://duckduckgo.com/?q=" + sender.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "+"));
                }
            }
        }
    }
    
    /// The view for capturing the scroll event for moving the window for picture in picture mode
    @IBOutlet weak var scrollEventCaptureView : KWScrollCaptureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // Style the window
        styleWindow();
        
        // If we didnt pass any arguments to the executable...
        if(NSProcessInfo.processInfo().arguments.count == 1) {
            // Open the homepage
            openUrl("https://duckduckgo.com");
        }
        // If we did pass arguments to the executable...
        else if(NSProcessInfo.processInfo().arguments.count > 1) {
            // If the argument wasnt -NSDocumentRevisionsDebugMode(Passed by Xcode when developing)...
            if(NSProcessInfo.processInfo().arguments[1] != "-NSDocumentRevisionsDebugMode") {
                // Open the first argument in the web view
                openUrl(NSProcessInfo.processInfo().arguments[1]);
            }
            // If the argument was -NSDocumentRevisionsDebugMode...
            else {
                // Open the homepage
                openUrl("https://duckduckgo.com");
            }
            
            // If there was a third argument and it is "true"...
            if(NSProcessInfo.processInfo().arguments.count > 2) {
                if(NSProcessInfo.processInfo().arguments[2] == "true") {
                    // Hide the titlebar
                    toggleTitlebar();
                }
            }
        }
        
        // Update the web UI
        updateWebUI();
    }
    
    override func viewWillAppear() {
        // If there was a fifth argument...
        if(NSProcessInfo.processInfo().arguments.count > 4) {
            // Set the PiP position to the entered number as a KWPiPCorner
            pipPosition = KWPiPCorner(rawValue: Int(NSString(string: NSProcessInfo.processInfo().arguments[4]).intValue))!;
        }
        
        // If there was a fourth argument and it is "true"...
        if(NSProcessInfo.processInfo().arguments.count > 3) {
            if(NSProcessInfo.processInfo().arguments[3] == "true") {
                // Enable PiP mode
                togglePiP();
            }
        }
    }
    
    /// Opens the given URL in this window's web view
    func openUrl(url : String) {
        // If the given URL is valid...
        if(NSURL(string: url) != nil) {
            /// The URL request to open the given URL
            let urlRequest : NSURLRequest = NSURLRequest(URL: NSURL(string: url)!);
            
            // Open the URL
            webView.mainFrame.loadRequest(urlRequest);
        }
        // If the given URL is invalid...
        else {
            // Print to the log that the URL was invalid
            print("ViewController: URL \"\(url)\" is invalid, cant open");
        }
    }
    
    /// Updates the URL field and back/forward buttons to match the current info in the web view
    func updateWebUI() {
        // Enable/disable the ack and forward buttons based on if we can go back or forward
        titlebarNavigationSegmentedControl.setEnabled(webView.canGoBack, forSegment: 0);
        titlebarNavigationSegmentedControl.setEnabled(webView.canGoForward, forSegment: 1);
        
        // If the URL field isnt selected...
        if(window.firstResponder != titlebarUrlTextField) {
            // Set the URL field's value to the current URL
            titlebarUrlTextField.stringValue = webView.mainFrameURL;
        }
    }
    
    func webView(sender: WebView!, didStartProvisionalLoadForFrame frame: WebFrame!) {
        // Update the web UI
        updateWebUI();
    }
    
    func windowDidExitFullScreen(notification: NSNotification) {
        // Re-hide the window's titlebar
        window.standardWindowButton(.CloseButton)?.superview?.superview?.removeFromSuperview();
        
        // Make the real titlebar aqua again
        window.appearance = NSAppearance(named: NSAppearanceNameAqua);
    }
    
    func windowDidEnterFullScreen(notification: NSNotification) {
        // Make the real titlebar vibrant dark
        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark);
    }
    
    /// Is picture in picture mode enabled?
    var pipEnabled : Bool = false;
    
    /// Toggles picture in picture mode
    func togglePiP() {
        // Toggle pipEnabled
        pipEnabled = !pipEnabled;
        
        // If PiP is now enabled...
        if(pipEnabled) {
            // Enable PiP
            enablePiP();
        }
        // If PiP is now disabled...
        else {
            // Disable PiP
            disablePiP();
        }
    }
    
    /// Enables Picture in Picture mode
    func enablePiP() {
        // Make the window float
        window.level = 20;
        
        // Make the window connect spaces
        window.collectionBehavior = .CanJoinAllSpaces;
        
        // Resize the window for PiP mode
        pipResize();
        
        // Move the window to the bottom right corner
        pipMoveWindowToCorner(pipPosition);
    }
    
    /// Disables Picture in Picture mode
    func disablePiP() {
        // Stop the window from floating
        window.level = Int(CGWindowLevelKey.BaseWindowLevelKey.rawValue);
        
        // Stop the window from connecting spaces
        window.collectionBehavior = .Default;
    }
    
    /// Is the tilebar visible?
    var titlebarVisible : Bool = true;
    
    /// Toggles the titlebar
    func toggleTitlebar() {
        // Toggle titlebarVisible
        titlebarVisible = !titlebarVisible;
        
        // If the titlebar is now visible...
        if(titlebarVisible) {
            // Show the titlebar
            showTitlebar();
        }
        // If the titlebar is now hidden...
        else {
            // Hide the titlebar
            hideTitlebar();
        }
    }
    
    /// Hides the titlebar
    func hideTitlebar() {
        // Hide the titlebar
        titlebarVisualEffectView.animator().alphaValue = 0;
        
        // Disable all the titlebar items
        titlebarNavigationSegmentedControl.enabled = false;
        titlebarRefreshButton.enabled = false;
        titlebarUrlTextField.enabled = false;
    }
    
    /// Shows the titlebar
    func showTitlebar() {
        // Show the titlebar
        titlebarVisualEffectView.animator().alphaValue = 1;
        
        // Enable all the titlebar items
        titlebarNavigationSegmentedControl.enabled = true;
        titlebarRefreshButton.enabled = true;
        titlebarUrlTextField.enabled = true;
    }
    
    /// Makes titlebarUrlTextField the first responder(Used for menu items)
    func selectUrlField() {
        // Make titlebarUrlTextField the first responder
        window.makeFirstResponder(titlebarUrlTextField);
    }
    
    /// Goes back a page in the web view(Used for menu items)
    func goBack() {
        // Go back
        webView.goBack();
    }
    
    /// Goes forward a page in the web view(Used for menu items)
    func goForward() {
        // Go forward
        webView.goForward();
    }
    
    /// Reloads the web view(Used for menu items)
    func reload() {
        // Reload
        webView.reload(self);
    }
    
    /// Sets up the menu items for this controller
    func setupMenuItems() {
        // Setup the menu items
        // Set the targets
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSelectUrlField.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleTitlebar.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemGoBack.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemGoForward.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemReload.target = self;
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePictureInPictureMode.target = self;
        
        // Set the actions
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemSelectUrlField.action = Selector("selectUrlField");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemToggleTitlebar.action = Selector("toggleTitlebar");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemGoBack.action = Selector("goBack");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemGoForward.action = Selector("goForward");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemReload.action = Selector("reload");
        (NSApplication.sharedApplication().delegate as! AppDelegate).menuItemTogglePictureInPictureMode.action = Selector("togglePiP");
    }
    
    /// Styles the window
    func styleWindow() {
        // Get the window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Make the window borderless rounded
        window.styleMask |= NSFullSizeContentViewWindowMask;
        window.titlebarAppearsTransparent = true;
        window.standardWindowButton(.CloseButton)?.superview?.superview?.removeFromSuperview();
        
        // Setup the visual effect views
        titlebarVisualEffectView.material = .Dark;
        
        // Set the window's delegate
        window.delegate = self;
        
        // Set the web view's frame's delegate
        webView.frameLoadDelegate = self;
        
        // Setup the menu items
        setupMenuItems();
        
        // Setup scrollEventCaptureView
        scrollEventCaptureView.scrollEventTarget = self;
        scrollEventCaptureView.scrollEventAction = Selector("scrollWheel:");
        
        // Add the flags changed observers
        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask, handler: modifiersChangedGlobal);
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask, handler: modifiersChanged);
    }
    
    func modifiersChangedGlobal(theEvent : NSEvent) {
        // Call modifiersChanged with the event
        modifiersChanged(theEvent);
    }
    
    func modifiersChanged(theEvent : NSEvent) -> NSEvent {
        // If we are in PiP mode...
        if(pipEnabled) {
            // If we arent holding command...
            if(!theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask)) {
                // Enable scrolling in the web view
                webView.mainFrame.frameView.allowsScrolling = true;
            }
                // If we are holding command...
            else {
                // Disable scrolling in the webview so we can capture the event for PiP moving
                webView.mainFrame.frameView.allowsScrolling = false;
            }
        }
        
        return theEvent;
    }

    /// How much padding to put on the edge of the window in PiP mode
    let pipEdgePadding : CGFloat = 22;
    
    /// The current PiP position of the window
    var pipPosition : KWPiPCorner = KWPiPCorner.BottomRight;
    
    /// Resizes the window for PiP so it is in 16:9
    func pipResize() {
        /// The aspect ratio for 16:9
        let aspectRatio : CGFloat = 9 / 16;
        
        /// The new height for the window
        let newHeight : CGFloat = aspectRatio * window.frame.width;
        
        // Set the window's frame so its width is the same but the height adjusts so its in 16:9
        window.setFrame(NSRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: newHeight), display: false, animate: false);
    }
    
    /// Moves the window to the given KWPiPCorner
    func pipMoveWindowToCorner(corner : KWPiPCorner) {
        // Move the window depending on the corner
        switch(corner) {
            case .BottomLeft:
                pipMoveWindowToBottomLeftCorner();
                break;
            case .BottomRight:
                pipMoveWindowToBottomRightCorner();
                break;
            case .TopLeft:
                pipMoveWindowToTopLeftCorner();
                break;
            case .TopRight:
                pipMoveWindowToTopRightCorner();
                break;
        }
    }
    
    /// Moves the window to the bottom left corner of the screen(With PiP padding)
    func pipMoveWindowToBottomLeftCorner() {
        // Move the window
        window.setFrame(NSRect(x: pipEdgePadding, y: pipEdgePadding, width: window.frame.width, height: window.frame.height), display: false, animate: true);
    }
    
    /// Moves the window to the top left corner of the screen(With PiP padding)
    func pipMoveWindowToTopLeftCorner() {
        /// The size of the current size
        let screenSize : NSRect = NSScreen.mainScreen()!.frame;
        
        // Move the window
        window.setFrame(NSRect(x: pipEdgePadding, y: (screenSize.height - pipEdgePadding) - window.frame.height, width: window.frame.width, height: window.frame.height), display: false, animate: true);
    }

    /// Moves the window to the bottom right corner of the screen(With PiP padding)
    func pipMoveWindowToBottomRightCorner() {
        /// The size of the current size
        let screenSize : NSRect = NSScreen.mainScreen()!.frame;
        
        // Move the window
        window.setFrame(NSRect(x: (screenSize.width - pipEdgePadding) - window.frame.width, y: pipEdgePadding, width: window.frame.width, height: window.frame.height), display: false, animate: true);
    }
    
    /// Moves the window to the top right corner of the screen(With PiP padding)
    func pipMoveWindowToTopRightCorner() {
        /// The size of the current size
        let screenSize : NSRect = NSScreen.mainScreen()!.frame;
        
        // Move the window
        window.setFrame(NSRect(x: (screenSize.width - pipEdgePadding) - window.frame.width, y: (screenSize.height - pipEdgePadding) - window.frame.height, width: window.frame.width, height: window.frame.height), display: false, animate: true);
    }

    override func scrollWheel(theEvent: NSEvent) {
        // If we are holding command and PiP mode is enabled...
        if(theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) && pipEnabled) {
            // Set the window corner based on the scroll delta. This is highly repetitive, yet easy to understand so no comments here
            
            if(theEvent.scrollingDeltaY > 0) {
                if(pipPosition == .BottomLeft) {
                    pipPosition = .TopLeft;
                }
                else if(pipPosition == .BottomRight) {
                    pipPosition = .TopRight;
                }
            }
            else if(theEvent.scrollingDeltaY < 0) {
                if(pipPosition == .TopLeft) {
                    pipPosition = .BottomLeft;
                }
                else if(pipPosition == .TopRight) {
                    pipPosition = .BottomRight;
                }
            }
            else if(theEvent.scrollingDeltaX < 0) {
                if(pipPosition == .BottomRight) {
                    pipPosition = .BottomLeft;
                }
                else if(pipPosition == .TopRight) {
                    pipPosition = .TopLeft;
                }
            }
            else if(theEvent.scrollingDeltaX > 0) {
                if(pipPosition == .BottomLeft) {
                    pipPosition = .BottomRight;
                }
                else if(pipPosition == .TopLeft) {
                    pipPosition = .TopRight;
                }
            }
            
            // Move the window to the new corner
            pipMoveWindowToCorner(pipPosition);
        }
    }
}

/// The corners for referring to PiP window positions
enum KWPiPCorner: Int {
    case BottomLeft
    case BottomRight
    case TopLeft
    case TopRight
}