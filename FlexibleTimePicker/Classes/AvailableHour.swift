//
//  Time.swift
//  FlexibleTimePicker
//
//  Created by ebru gungor on 19/01/2018.
//

import UIKit

public struct AvailableHour {
    var startHour: Date
    var endHour: Date
    
    public init(startHour: Date, endHour:Date) {
        self.startHour = startHour
        self.endHour = endHour
    }
}
