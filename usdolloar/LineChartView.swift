//
//  LineChartView.swift
//  usdolloar
//
//  Created by Roc Yu on 16/2/28.
//  Copyright © 2016年 Roc Yu. All rights reserved.
//

import Cocoa

class LineChartView: NSView {
    var data: [Double] = [Double]()
    var categories: [String] = [String]()
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let points = calculatePoints()
        let line = NSBezierPath(rect: dirtyRect);

        for (index, point) in points.enumerate() {
            line.lineToPoint(NSPoint(x: point.x, y: point.y))
        }
        line.lineWidth = 2.0
        NSColor.blackColor().setStroke()
        line.stroke()
    }
    

    func setLineChartData(categories: [String], data: [Double]) {
        self.categories = categories
        self.data = data
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    func calculateMedian() -> Double {
        if data.count == 0 {
            return 0.0
        }
        let min = findMinValue()
        let max = findMaxValue()
        return (min + max) / 2.0
    }

    func findMaxValue() -> Double {
        var max = 0.0
        for d in data {
            if d > max {
                max = d
            }
        }
        return max
    }

    func findMinValue() -> Double {
        if data.count == 0 {
            return 0.0
        }
        var min = data[0]
        for d in data {
            if d < min {
                min = d
            }
        }
        return min
    }
    
    struct Point {
        var x: Double
        var y: Double
    }

    // width, height
    // calculate start point y (height / 2) mapping to avg value
    // x start with 0 per width/data count
    // max -> height, min -> 0
    
    func calculatePoints() -> [Point] {
        if data.count == 0 {
            return [Point]()
        }
        var points = [Point]()
        let perPointX = Double(self.frame.size.width) / Double(data.count)
        let maxValue = findMaxValue()
        let minValue = findMinValue()
        let perPointY = (maxValue - minValue) / Double(self.frame.size.height)
        for (index, d) in data.enumerate() {
            let x = Double(index) * perPointX
            let y = (d - minValue) / perPointY

            let point = Point(x: x, y: y)
            points.append(point)
        }
        return points
    }
}
