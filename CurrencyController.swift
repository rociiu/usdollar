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
    var store = CurrencyStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func exitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    override func viewDidAppear() {
        store.fetchPastTwentyDaysCurrencies({
            (data: [NSDate: Double]) in
            var rawData = [Double]()
            let sortedKeys = data.keys.sort({
                (date1, date2) in
                return date1.compare(date2) == NSComparisonResult.OrderedAscending
            })
            for key in sortedKeys {
                rawData.append(data[key]!)
            }
            self.lineChartView.setLineChartData(["a"], data: rawData)
        })
    }
}
