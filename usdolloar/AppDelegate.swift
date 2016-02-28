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
    let usdCurrency = 0.0
    let popover = NSPopover()
    let store = CurrencyStore()
    var timer = NSTimer?()
    var eventMonitor = EventMonitor?()

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.title = "$\(usdCurrency)"
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = CurrencyController(nibName: "CurrencyController", bundle: nil)
        
        self.refreshCurrency()
 
        eventMonitor = EventMonitor(mask: NSEventMask.LeftMouseDownMask.union(NSEventMask.RightMouseDownMask)) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event!)
            }
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60 * 60, target: self, selector: "refreshCurrency", userInfo: nil, repeats: true)
    }

    func refreshCurrency() {
        store.fetchLatestCurrency({
            (currency: Double) in
            if let button = self.statusItem.button {
                button.title = "$\(currency)"
            }
        })
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
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject) {
        eventMonitor?.stop()
        popover.performClose(sender)
    }
}

