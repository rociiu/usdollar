//
//  CurrencyController.swift
//  usdolloar
//
//  Created by Roc Yu on 16/2/27.
//  Copyright © 2016年 Roc Yu. All rights reserved.
//

import Cocoa

class CurrencyController: NSViewController {

    @IBOutlet weak var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func exitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    override func viewDidAppear() {
        lineChartView.setLineChartData(["a", "b", "c", "d", "e"], data: [6.51, 6.52, 6.53, 6.54, 6.59])
    }
}
