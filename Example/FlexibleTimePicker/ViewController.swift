//
//  ViewController.swift
//  FlexibleTimePicker
//
//  Created by ebrugungorist@gmail.com on 01/22/2018.
//  Copyright (c) 2018 ebrugungorist@gmail.com. All rights reserved.
//

import UIKit
import FlexibleTimePicker

class ViewController: UIViewController {

    @IBOutlet weak var flexibleTimePicker: FlexibleTimePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setAvailability()
    }
    
    func setAvailability() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.longDateFormat()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let startDateString1 = "2018-01-22T10:20:00.000Z" //UTC Hour
        let endDateString1 = "2018-01-22T13:40:00.000Z" //UTC  hour
        
        let startDate1 = dateFormatter.date(from: startDateString1)
        let endDate1 = dateFormatter.date(from: endDateString1)
        
        let startDateString2 = "2018-01-22T15:30:00.000Z" //UTC hour
        let endDateString2 = "2018-01-22T19:30:00.000Z" //UTC  hour
        
        let startDate2 = dateFormatter.date(from: startDateString2)
        let endDate2 = dateFormatter.date(from: endDateString2)
        
        let available1 = AvailableHour(startHour: startDate1!, endHour: endDate1!)
        let available2 = AvailableHour(startHour: startDate2!, endHour: endDate2!)
        let availableHours = [available1, available2]
        self.flexibleTimePicker.setAvailability(availableHours: availableHours)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

