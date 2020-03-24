//
//  Extensions.swift
//  CovidTracker
//
//  Created by Victor Santos on 3/24/20.
//  Copyright © 2020 Victor Santos. All rights reserved.
//

import Foundation

extension String {
    func toDateString() -> String {
          
      let input = self
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard  let date = formatter.date(from: input) else { return ""}
      
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter.string(from: date)
        
    }
}
