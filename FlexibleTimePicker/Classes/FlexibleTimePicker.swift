//
//  FlexibleTimePicker.swift
//  TimePicker
//
//  Created by ebru gungor on 02/01/2018.
//  Copyright © 2018 ebru gungor. All rights reserved.
//

import UIKit

@IBDesignable
public class FlexibleTimePicker: UIView, FlexibleTimePickedDelegate {
    
    //MARK: Container
    
    @IBInspectable public var fromCurrentHour: Bool = false
    @IBInspectable public var startHour: Int = 1
    @IBInspectable public var endHour: Int = 24
    
    @IBInspectable public var allowsMultipleSelection: Bool = false
    @IBInspectable public var scaleCellHeightToFit: Bool = false
    
    @IBInspectable public var removeCellBorders:Bool = false
    
    var timeFrequency: TimeFrequency = .FullHour
    @IBInspectable public var minuteFrequency : Int {
        get {
            return self.timeFrequency.rawValue
        }
        set( timeFrequency) {
            self.timeFrequency = TimeFrequency(rawValue: timeFrequency) ?? .FullHour
        }
    }
    
    //MARK: Cell
    
    @IBInspectable public var cellBorderThickness: CGFloat = 0.10
    @IBInspectable public var cellBorderColor: UIColor! = UIColor.lightGray
    @IBInspectable public var cellOnlyBottomBorder: Bool = false
    @IBInspectable public var cellHeight: CGFloat = 40
    @IBInspectable public var cellCountPerRow: Int = 4
    @IBInspectable public var cellTextColor : UIColor = UIColor.black
    @IBInspectable public var cellHighlightedTextColor: UIColor = UIColor.white
    @IBInspectable public var cellBackgroundColor: UIColor = UIColor.white
    
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var collectionView: TimePickerCollectionView!
    
    public var chosenHours = [Hour]()
    
    public weak var delegate: FlexibleTimePickedDelegate?
    
    //MARK: Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.setProperties()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setProperties()
    }
    
    private func setProperties() {
        self.refreshUI()
        self.collectionView.timeDelegate = self
    }
    
    private func commonInit() {
        Bundle(for: FlexibleTimePicker.self).loadNibNamed("FlexibleTimePicker", owner: self, options: nil)
        guard let content = view else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
    //MARK: FlexibleTimePickedDelegate
    
    public func timePicked(chosenHours: [Hour]) {
        self.chosenHours = chosenHours
        self.delegate?.timePicked(chosenHours: chosenHours)
        //print(getSelectedTimeSlots())
    }
    
    //MARK: UI
    
    public func refreshUI() {
        self.collectionView.setProperties(timeFrequency: timeFrequency,
                                          fromCurrentHour: fromCurrentHour,
                                          startHour: startHour,
                                          endHour: endHour,
                                          multipleSelection: allowsMultipleSelection,
                                          removeCellBorders: removeCellBorders,
                                          cellThickness: cellBorderThickness,
                                          cellBorderColor: cellBorderColor,
                                          onlyBottomBorder: cellOnlyBottomBorder,
                                          scaleCellHeightToFit: scaleCellHeightToFit,
                                          cellHeight: cellHeight,
                                          cellCountPerRow: cellCountPerRow,
                                          cellTextColor: cellTextColor,
                                          cellHighlightedTextColor: cellHighlightedTextColor,
                                          cellBackgroundColor: cellBackgroundColor)
    }
    
    public func setAvailability(availableHours:[AvailableHour]) {
        collectionView.setAvailability(availableHours:availableHours)
    }
    
    //MARK: Date
    
    public func getSelectedDateSlotsForDate(date:Date) -> [Date] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.shortDateFormat()
        let dateString = dateFormatter.string(from: date)
        let mappedArray = chosenHours.map({convertToDateFormat(dateString: dateString, hourString: $0.hourString, date: date)})
        return mappedArray
    }
    
    public func getSelectedDateSlotsForToday() -> [Date] {
        return self.getSelectedDateSlotsForDate(date: Date())
    }
    
    public func getSelectedTimeSlots() ->[String] {
        let timeSlots = self.chosenHours.map({getOnlyDateString(hour:$0)})
        return timeSlots
    }
    
    //MARK: Private
    
    private func getOnlyDateString(hour:Hour) -> String {
        return hour.hourString
    }
    
    private func convertToDateFormat(dateString: String, hourString:String, date:Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.longDateFormat()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let fullString = "\(dateString)T\(hourString):00.000Z"
        var dateUTC:Date?
        if hourString.hasPrefix("24") {
            dateUTC = self.getNextDayIfNeeded(date: date)
        } else {
            dateUTC = dateFormatter.date(from: fullString)!
        }
        return dateUTC!
    }
    
    private func getNextDayIfNeeded(date:Date) -> Date {
        let nextDay = date.dayAfter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.shortDateFormat()
        let dateString = dateFormatter.string(from: nextDay)
        let fullString = "\(dateString)T00:00:00.000Z"
        dateFormatter.dateFormat = Date.longDateFormat()
        return dateFormatter.date(from: fullString)!
    }
}

