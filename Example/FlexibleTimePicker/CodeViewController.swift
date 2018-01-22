//
//  CodeViewController.swift
//  FlexibleTimePicker_Example
//
//  Created by ebru gungor on 22/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlexibleTimePicker

class CodeViewController: UIViewController {
    
    var flexibleTimePicker: FlexibleTimePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        let margin = CGFloat(40)
        let container = CGRect(x: margin, y: margin, width: self.view.frame.width - (margin * 2), height: self.view.frame.height / 2)
        flexibleTimePicker = FlexibleTimePicker(frame: container)
        self.view.addSubview(flexibleTimePicker!)
        self.setCustomProperties()
    }
    
    func setCustomProperties() {
        flexibleTimePicker?.fromCurrentHour = false
        flexibleTimePicker?.allowsMultipleSelection = false
        flexibleTimePicker?.startHour = 9
        flexibleTimePicker?.endHour = 18
        flexibleTimePicker?.removeCellBorders = false
        flexibleTimePicker?.minuteFrequency = 15
        flexibleTimePicker?.cellBorderThickness = 2
        flexibleTimePicker?.cellBorderColor = UIColor.red
        flexibleTimePicker?.cellOnlyBottomBorder = false
        flexibleTimePicker?.cellHeight = 50
        flexibleTimePicker?.cellCountPerRow = 5

        
        flexibleTimePicker?.refreshUI()
    }
}
