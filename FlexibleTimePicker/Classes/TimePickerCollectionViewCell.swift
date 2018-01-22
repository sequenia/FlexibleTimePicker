//
//  TimeCollectionViewCell.swift
//  TimePicker
//
//  Created by ebru gungor on 06/12/2017.
//  Copyright © 2017 ebru gungor. All rights reserved.
//

import UIKit

class TimePickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rectangleLines: CellBorderView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setBorderProperties(removeBorders:Bool, thickness:CGFloat, borderColor:UIColor, onlyBottomBorder:Bool) {
        self.rectangleLines.lineColor = borderColor
        self.rectangleLines.thickness = thickness
        self.rectangleLines.onlyBottomBorder = onlyBottomBorder
        self.rectangleLines.removeBorders = removeBorders
        self.rectangleLines.setNeedsDisplay()
    }
}
