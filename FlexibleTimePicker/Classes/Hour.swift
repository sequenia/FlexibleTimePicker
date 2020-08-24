//
//  Hour.swift
//  TimePicker
//
//  Created by ebru gungor on 11/01/2018.
//  Copyright © 2018 ebru gungor. All rights reserved.
//

import UIKit

public struct Hour {
    var hourString:String
    var index:Int
    
    public init(hourString: String, index:Int) {
        self.hourString = hourString
        self.index = index
    }
}
