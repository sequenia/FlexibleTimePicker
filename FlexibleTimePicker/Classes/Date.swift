//
//  Date.swift
//  TimePicker
//
//  Created by ebru gungor on 11/01/2018.
//  Copyright © 2018 ebru gungor. All rights reserved.
//

import UIKit

public extension Date {
    
    var dayAfter:Date {
        let oneDay:Double = 60 * 60 * 24
        return self.addingTimeInterval(oneDay)
    }
    
    var dayBefore:Date {
        let oneDay:Double = 60 * 60 * 24
        return self.addingTimeInterval(-(Double(oneDay)))
    }
    
    static func longDateFormat() -> String {
        return "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    static func shortDateFormat() -> String {
        return "YYYY-MM-dd"
    }
}
