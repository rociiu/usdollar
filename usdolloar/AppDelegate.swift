//
//  AppDelegate.swift
//  usdolloar
//
//  Created by Roc Yu on 16/2/27.
//  Copyright © 2016年 Roc Yu. All rights reserved.
//

import Foundation
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let usdCurrency = 6.51
    let popover = NSPopover()
    let store = CurrencyStore()

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.title = "$\(usdCurrency)"
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = CurrencyController(nibName: "CurrencyController", bundle: nil)
        
        store.fetchLatestCurrency()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func togglePopover(sender: AnyObject) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(sender: AnyObject) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject) {
        popover.performClose(sender)
    }
}

