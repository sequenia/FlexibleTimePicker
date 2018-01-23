//
//  TimeCollectionViewCell.swift
//  TimePicker
//
//  Created by ebru gungor on 06/12/2017.
//  Copyright © 2017 ebru gungor. All rights reserved.
//

import UIKit


public protocol FlexibleTimePickedDelegate: NSObjectProtocol {
    func timePicked(chosenHours:[Hour])
}

@IBDesignable
class TimePickerCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var hourArray = [String]()
    private var disabledHours = [String]()
    
    private var chosenHours = [Hour]()
    
    private let fullHourMinutes = 60
    private let finalHour = 24
    private let dateFormatter = DateFormatter()

    weak open var timeDelegate: FlexibleTimePickedDelegate?
    
    var timeFrequency: TimeFrequency = .FullHour
    var fromCurrentHour: Bool = false
    var startHour: Int = 1
    var endHour: Int = 24
    var removeCellBorders: Bool = false
    
    var cellThickness: CGFloat = 0.10
    var cellBorderColor: UIColor! = UIColor.darkGray
    var onlyBottomBorder: Bool = false
    
    var scaleCellHeightToFit: Bool = false
    
    var cellHeight: CGFloat = 40
    var cellCountPerRow: Int = 4
    
    var cellTextColor : UIColor = UIColor.black
    var cellHighlightedTextColor: UIColor = UIColor.white
    var cellBackgroundColor: UIColor = UIColor.white
    
    //MARK: Init methods
  
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setUISettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUISettings()
    }
    
    //MARK: UI methods
    
    func setProperties(timeFrequency:TimeFrequency, fromCurrentHour: Bool, startHour: Int, endHour: Int, multipleSelection:Bool, removeCellBorders:Bool, cellThickness:CGFloat, cellBorderColor:UIColor, onlyBottomBorder:Bool, scaleCellHeightToFit: Bool, cellHeight: CGFloat, cellCountPerRow: Int, cellTextColor: UIColor, cellHighlightedTextColor: UIColor, cellBackgroundColor: UIColor) {
        self.timeFrequency = timeFrequency
        self.fromCurrentHour = fromCurrentHour
        self.startHour = startHour
        self.endHour = endHour
        self.removeCellBorders = removeCellBorders
        self.allowsMultipleSelection = multipleSelection
        self.cellThickness = cellThickness
        self.cellBorderColor = cellBorderColor
        self.onlyBottomBorder = onlyBottomBorder
        self.scaleCellHeightToFit = scaleCellHeightToFit
        self.cellHeight = cellHeight
        self.cellCountPerRow = cellCountPerRow
        self.cellTextColor = cellTextColor
        self.cellHighlightedTextColor = cellHighlightedTextColor
        self.cellBackgroundColor = cellBackgroundColor
        self.refreshUI()
    }
    
    func refreshUI() {
        self.createDataArray()
        self.reloadData()
    }
    
    func refreshUIWithAvailability(availableHours:[AvailableHour]) {
        self.createDataArray()
        self.setAvailability(availableHours: availableHours)
    }
    
    func setUISettings() {
        self.register(UINib(nibName: "TimePickerCollectionViewCell",bundle: Bundle(for: TimePickerCollectionView.self)), forCellWithReuseIdentifier: "timeCell")
        self.delegate = self
        self.dataSource = self
        self.disabledHours = [String]();
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        self.reloadData()
    }
    
    func setCellSelectionStyle(_ cell: inout TimePickerCollectionViewCell, textColor: UIColor, backgroundColor: UIColor) {
        cell.timeLabel.textColor = textColor
        cell.backgroundColor = backgroundColor
    }
    
    func setDisabledCellSelectionStyle(_ cell: inout TimePickerCollectionViewCell, textColor: UIColor, backgroundColor: UIColor) {
        let opacity = CGFloat(0.3)
        cell.timeLabel.textColor = textColor.withAlphaComponent(opacity)
        cell.backgroundColor = backgroundColor.withAlphaComponent(opacity)
        cell.rectangleLines.lineColor = self.cellBorderColor.withAlphaComponent(opacity)
    }
    
    //MARK: Data methods
    
    func createDataArray() {
        if fromCurrentHour {
            dateFormatter.dateFormat = "H"
            dateFormatter.timeZone = TimeZone.current
            startHour = Int(dateFormatter.string(from: Date()))!
        }
        self.hourArray = self.getTimeArray()
    }
    
    func getTimeArray() -> [String] {
        var tempArray: Array = [String]();
        let value = timeFrequency.rawValue
        let multiplier = fullHourMinutes / value
        for i in startHour..<endHour {
            let hourString: String = self.getHourString(i: i)
            for j in 0..<multiplier {
                var minute = j * value
                if(minute == 60) {
                    minute = 0
                }
                let minuteString = self.getHourString(i: minute)
                tempArray.append("\(hourString):\(minuteString)")
            }
        }
        let end = getHourString(i: endHour)
        tempArray.append("\(end):00")
        return tempArray
    }
    
    func getHourString(i:Int) -> String {
        var hourString: String = "\(i)"
        if(i < 10) {
            hourString = "0\(i)"
        }
        return hourString
    }
    
    private func getDisabledHours(startHour: String, startMinute: String, endHour: String, endMinute: String) -> [String] {
        let startMinuteInt = Int(startMinute)
        let endMinuteInt = Int(endMinute)
        var startIndex : Int?
        var endIndex : Int?
        let disabledHours = self.hourArray.map { (hourString) -> String in
            if endIndex != nil {
                return ""
            } else {
                let minuteComp = hourString.suffix(2)
                let minuteCompInt = Int(minuteComp)
                
                //compare start of the hour
                compare(start: true, index: &startIndex, hourString: hourString, hour: startHour, minuteCompInt: minuteCompInt, minuteInt: startMinuteInt)
                
                //compare end of the hour
                compare(start: false, index: &endIndex, hourString: hourString, hour: endHour, minuteCompInt: minuteCompInt, minuteInt: endMinuteInt)
                
                if startIndex != nil {
                    return hourString
                } else {
                    return ""
                }
            }
        }
        
        return disabledHours
    }
    
    private func compare(start:Bool , index: inout Int?, hourString:String, hour: String, minuteCompInt: Int?, minuteInt: Int?) {
        let hourComp = hourString.hasPrefix(hour)
        if hourComp {
            if minuteCompInt != nil && minuteInt != nil {
                let value = timeFrequency.rawValue
                let multiplierActual = minuteCompInt! / value
                
                let multiplier = minuteInt! / value
                var mod = minuteInt! % value
                if value > minuteInt! {
                    mod = 0
                }
                
                let compareValue = value * multiplier
       
                if (start &&
                    (mod > 0 && minuteCompInt! >= compareValue) ||
                    (mod == 0 && minuteCompInt! == compareValue)) ||
                    
                    (!start &&
                    (mod > 0 && minuteCompInt! > compareValue && multiplierActual == (multiplier + 1)) ||
                    (mod > 0 && minuteCompInt! == compareValue && multiplierActual == multiplier) ||
                    (mod == 0 && minuteCompInt! == compareValue)) {
                    
                    index = self.hourArray.index(of: hourString)
                }
            }
        } else {
            //if the start hour is not visible on the screen.
            let startInt = Int(hourString.prefix(2))
            if start && index == nil && startInt! > Int(hour)! {
                index = self.hourArray.index(of: hourString)
            }
        }
    }
    
    func setAvailability(availableHours:[AvailableHour]) {
        let hours = availableHours.map { (availableHour) -> (String, String, String, String) in
            
            dateFormatter.dateFormat = "HH"
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let startHour = dateFormatter.string(from: availableHour.startHour)
            let endHour = dateFormatter.string(from: availableHour.endHour)
            dateFormatter.dateFormat = "mm"
            let startMinute = dateFormatter.string(from: availableHour.startHour)
            let endMinute = dateFormatter.string(from: availableHour.endHour)
            return (startHour, startMinute, endHour, endMinute)
        }
        
        var disabledHours = [String]()
        hours.forEach { (startHour, startMinute, endHour, endMinute) in
            let disabled = getDisabledHours(startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute)
            disabledHours += disabled
        }
        
        self.disabledHours = disabledHours
        self.reloadData()
        //print(disabledHours)
    }
    
    //MARK: Check methods
    
    func checkContains(indexPath: IndexPath) -> (Bool, Int) {
        let index = (indexPath as NSIndexPath).row
        let contains =  chosenHours.contains{ $0.index == index }
        return (contains, index)
    }
    
    func appendChosen(cell: inout TimePickerCollectionViewCell, hour: Hour) {
        self.setCellSelectionStyle(&cell, textColor: cellHighlightedTextColor, backgroundColor: self.cellBorderColor)
        self.chosenHours.append(hour)
    }
    
    func removeChosen(cell: inout TimePickerCollectionViewCell, hour: Hour) {
        self.setCellSelectionStyle(&cell, textColor: cellTextColor, backgroundColor: UIColor.white)
        let index = self.chosenHours.index(where: { $0.hourString == hour.hourString })
        self.chosenHours.remove(at: index!)
    }
    
    //MARK: UICollectionView Delegate and Datasource methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimePickerCollectionViewCell
        cell.isUserInteractionEnabled = true
        cell.setBorderProperties(removeBorders: self.removeCellBorders,
                                 thickness: self.cellThickness,
                                 borderColor: self.cellBorderColor,
                                 onlyBottomBorder: self.onlyBottomBorder)
        
        let cellText = self.hourArray[(indexPath as NSIndexPath).row]
        cell.timeLabel.text = cellText
        
        let contains =  self.checkContains(indexPath: indexPath)
        if contains.0 {
            self.setCellSelectionStyle(&cell, textColor: cellHighlightedTextColor, backgroundColor: self.cellBorderColor)
        } else {
            if self.disabledHours.contains(cellText) {
                cell.isUserInteractionEnabled = false
                self.setDisabledCellSelectionStyle(&cell, textColor: cellTextColor, backgroundColor: cellBackgroundColor)
            } else {
                self.setCellSelectionStyle(&cell, textColor: cellTextColor, backgroundColor: cellBackgroundColor)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = CGFloat(5 * self.cellCountPerRow)
        let viewWidth = self.frame.size.width - margin
        let cellWidth = viewWidth / CGFloat(self.cellCountPerRow)
        
        var rowCount : CGFloat = CGFloat(self.hourArray.count) / CGFloat(self.cellCountPerRow)
        let mod  = self.hourArray.count % self.cellCountPerRow
        if mod != 0 {
            rowCount += 1
        }
        
        var cellHeight: CGFloat = self.cellHeight
        if self.scaleCellHeightToFit {
            let viewHeight = self.frame.size.height
            cellHeight = viewHeight / rowCount
            self.isScrollEnabled = false
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contains =  self.checkContains(indexPath: indexPath)
        let hour = Hour(hourString: self.hourArray[contains.1], index: contains.1)
        var cell = self.cellForItem(at: indexPath) as! TimePickerCollectionViewCell
        if allowsMultipleSelection {
            if !contains.0 {
                self.appendChosen(cell: &cell, hour: hour)
            } else {
                self.removeChosen(cell: &cell, hour: hour)
            }
        } else {
            if !contains.0 {
                self.chosenHours.removeAll()
                self.appendChosen(cell: &cell, hour: hour)
                self.reloadData()
            } else {
                //Do nothing
            }
        }
        var ordered = chosenHours
        if chosenHours.count > 1 {
            ordered = chosenHours.sorted(by: { $0.index < $1.index } )
        }
        self.timeDelegate?.timePicked(chosenHours: ordered)
        
    }
    
}
