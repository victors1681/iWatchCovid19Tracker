//
//  Chart.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/23/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//
import SwiftUI
import YOChartImageKit

class Graph {
    func chart(states: [StateDaily]?) -> Image? {
        
        guard let cases = states else { return nil }
        var positives = cases.map{ return $0.positive }
        positives.reverse()
        let image = YOBarChartImage()
        image.strokeWidth = 0
        image.fillColor = UIColor(red: 179/255, green: 14/255, blue: 14/255, alpha: 0.7)
        image.values = positives as! [NSNumber]
        let i = image.draw(CGRect(x: 0, y: 0, width: 140, height: 60), scale: 2)
        
        return Image(uiImage: i)
    }
    
}
