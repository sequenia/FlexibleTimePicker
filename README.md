# FlexibleTimePicker
With this time picker widget, you will be able to add a flexible and easy to use time picker.

Example design:

### Note: The date picker shown in the picture is not included in this pod. This pod only includes TimePicker shown on the bottom segment of the image.
### For date picker credits go to: ![CLWeeklyCalendarView](https://github.com/clisuper/CLWeeklyCalendarView)

![unnamed-12.jpg](https://s13.postimg.org/45ar6i9fb/unnamed-12.jpg)


# Build Requirements

### iOS 9.3+
### Swift 4.0

# Installation

pod 'FlexibleTimePicker'

# Adding To Project

After pod installation add the module via @import FlexibleTimePicker

# Usage

##  You may add via interface designer

### 1. Add the resource class

![Screen_Shot_2018-01-22_at_16.10.50.png](https://s13.postimg.org/mywk3fn1z/Screen_Shot_2018-01-22_at_16.10.50.png)

### 2. Set required view properties

![Screen_Shot_2018-01-22_at_16.10.34.png](https://s13.postimg.org/4jc360ls7/Screen_Shot_2018-01-22_at_16.10.34.png)

Following properties can be set:

#### Container properties


    fromCurrentHour : Bool, by default false. This property is setting the start hour by the same hour as the current hour of the device time zone.
    
    startHour: Int, by default 1 (1am). In case 'fromCurrentHour' is set, this property will be overwritten.
    
    endHour: Int, by default 24 (12am). This is the end hour that will be shown in the time picker. For instance closing hour of your shop.
    
    allowsMultipleSelection: Bool by default false. In case 'fromCurrentHour' is set, this property will be overwritten.
    
    scaleCellHeightToFit: Bool , by default false. The container of the FlexibleTimePicker will not be scrollable but i will scale all the cells to fit them to the given height of the container. This property overwrites: cellHeight
    
    removeCellBorders : Bool, by default false. This property removes the borders that surrounding the time labels.
    
    minuteFrequency: Int, by default 60, choices for minute frequency: 5,10,15,30,60. 60 minutes means hourly base data points. For instance: 01:00,02:00,03:00. If set to other values such as: 15, then it will be as follows: 01:15, 01:30, 01:45, etc.

#### Cell properties

    cellBorderThickness : CGFloat, by default 0.1.
    cellBorderColor : UIColor, by default lightGray
    cellOnlyBottomBorder : Bool, by default false
    cellHeight : CGFloat, by default 40
    cellCountPerRow : Int, by default 4
    cellTextColor : UIColor, by default black
    cellHighlightedTextColor : UIColor, by default white
    cellBackgroundColor UIColor, by default white

## You may add via code

### Example:

    import FlexibleTimePicker
    
    var flexibleTimePicker: FlexibleTimePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CGRect(x: 20, y: 50, width: 250, height: 500)
        flexibleTimePicker = FlexibleTimePicker(frame: container)
        self.view.addSubview(flexibleTimePicker!)
        self.setCustomProperties()
    }

    //Assign your custom properties and call refreshUI method
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

## Return picked hour(s) as an array

1. Add FlexibleTimePickedDelegate to the UIViewController that you have FlexibleTimePicker object.
2. Assign delegate to the UIViewController --> self.flexibleTimePicker.delegate = self
3. Add delegate method called : timePicked.


        func timePicked(chosenHours: [Hour]) {
            //ordered hour strings as an array
            print("Hours: \(chosenHours)")
            
            let dates = self.flexibleTimePicker.getSelectedDateSlotsForToday()
            print("Chosen dates for today: \(dates)")
            
            let datesForYesterday = self.flexibleTimePicker.getSelectedDateSlotsForDate(date: Date().dayBefore)
            print("Day before: \(datesForYesterday)")
        }


Please contact with me directly  from ebrugungorist@gmail.com, in case of any new feature request. I will be happy to provide more support. :)


