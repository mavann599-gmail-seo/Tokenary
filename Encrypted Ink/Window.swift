// Copyright © 2021 Encrypted Ink. All rights reserved.

import Cocoa

struct Window {
    
    static func showNew() -> NSWindowController {
        closeAll()
        let windowController = new
        activate(windowController)
        return windowController
    }
    
    static func activate(_ windowController: NSWindowController) {
        windowController.showWindow(nil)
        activateWindow(windowController.window)
    }
    
    static func activateWindow(_ window: NSWindow?) {
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
    
    static func closeAllAndActivateBrowser() {
        closeAll()
        activateBrowser()
    }
    
    static func closeAll(updateStatusBarItem: Bool = true) {
        NSApplication.shared.windows.forEach { $0.close() }
        if updateStatusBarItem {
            Agent.shared.setupStatusBarItem()
        }
    }
    
    static func activateBrowser() {
        // TODO: support more browsers
        for bundleId in ["com.apple.Safari", "com.google.Chrome"] {
            if let browser = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).first {
                browser.activate(options: .activateIgnoringOtherApps)
                return
            }
        }
    }
    
    static var current: NSWindowController? {
        return NSApplication.shared.windows.first?.windowController
    }
    
    static var new: NSWindowController {
        return NSStoryboard.main.instantiateInitialController() as! NSWindowController
    }
    
}

extension NSStoryboard {
    static let main = NSStoryboard(name: "Main", bundle: nil)
}

func instantiate<ViewController: NSViewController>(_ type: ViewController.Type) -> ViewController {
    return NSStoryboard.main.instantiateController(withIdentifier: String(describing: type)) as! ViewController
}
