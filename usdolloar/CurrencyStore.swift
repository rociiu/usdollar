//
//  CurrencyStore.swift
//  usdolloar
//
//  Created by Roc Yu on 16/2/27.
//  Copyright © 2016年 Roc Yu. All rights reserved.
//

import Foundation

class CurrencyStore {
    let latestCurrency: Float = 0.0
    
    func fetchLatestCurrency(completeHanlder: Double -> Void) {
        let urlString = "https://api.fixer.io/latest?base=USD"
        
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
                        print(currency)
                        completeHanlder(currency)
                    } catch {
                        print("error")
                    }
                }
            }
            
            dataTask.resume()
        }
        
    }
    
}