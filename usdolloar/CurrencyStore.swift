//
//  CurrencyStore.swift
//  usdolloar
//
//  Created by Roc Yu on 16/2/27.
//  Copyright © 2016年 Roc Yu. All rights reserved.
//

import Foundation

extension Int {
    var daysAgo: NSDate {
        let earlyDate = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.Day,
            value: -self,
            toDate: NSDate(),
            options: NSCalendarOptions())
        return earlyDate!
    }
}

class CurrencyStore {
    let latestCurrency: Float = 0.0
    var pastWeekCurrencies: [NSDate: Double] = [NSDate: Double]()
    
    func fetchLatestCurrency(completeHanlder: Double -> Void) {
        let date = NSDate()
        self.fetchCurrencyWithDate(date, completeHandler: completeHanlder)
    }

    func fetchCurrencyWithDate(date: NSDate, completeHandler: Double -> Void) {
        let dateString = self.dateToString(date)
        let urlString = "https://api.fixer.io/\(dateString)?base=USD"
        
        if let url = NSURL(string: urlString) {
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            let dataTask = session.dataTaskWithURL(url) {
                (data: NSData?, response: NSURLResponse?, error: NSError?) in
                if data == nil {
                    print("dont have data")
                } else {
                    var json: [String: AnyObject]
                    do {
                        json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String: AnyObject]
                        let rates = json["rates"] as! [String: AnyObject]
                        let currency = rates["CNY"] as! Double
                        completeHandler(currency)
                    } catch {
                        print("error")
                    }
                }
            }
            
            dataTask.resume()
        }
    }

    func fetchPastTwentyDaysCurrencies(completeHanlder: [NSDate: Double] -> Void) {
        var dates = [NSDate]()
        for i in 1...20 {
            dates.append(i.daysAgo)
        }
        for date in dates {
            self.fetchCurrencyWithDate(date, completeHandler: {
                (currency: Double) in
                self.pastWeekCurrencies[date] = currency
                if self.pastWeekCurrencies.count == 20 {
                    completeHanlder(self.pastWeekCurrencies)
                }
            })
        }
    }

    func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(date)
    }
}