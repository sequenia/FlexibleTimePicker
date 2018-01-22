//
//  Line.swift
//  TimePicker
//
//  Created by ebru gungor on 11/01/2018.
//  Copyright © 2018 ebru gungor. All rights reserved.
//

import UIKit

class CellBorderView: UIView {

    var thickness: CGFloat = 0.10
    var lineColor: UIColor! = UIColor.gray
    var onlyBottomBorder: Bool = false
    var removeBorders: Bool = false
    
    override func draw(_ rect: CGRect) {
        if !removeBorders {
            let width = self.bounds.width - (thickness * 2)
            let height = self.bounds.height - (thickness * 2)
            if(onlyBottomBorder) {
                self.drawLine(rect: CGRect(x: thickness, y: height - thickness, width: width, height: thickness)) //bottom
            } else {
                var leftOver = 1 - thickness
                if thickness > 1 {
                    leftOver = thickness
                }
                self.drawLine(rect: CGRect(x: thickness, y: thickness, width: thickness, height: height - leftOver)) //left
                self.drawLine(rect: CGRect(x: thickness, y: thickness, width: width - leftOver, height: thickness)) //top
                self.drawLine(rect: CGRect(x: thickness, y: height - thickness, width: width - leftOver, height: thickness)) //bottom
                self.drawLine(rect: CGRect(x: width - thickness, y: thickness, width: thickness, height: height - leftOver)) //right
            }
        }
        super.draw(rect)
        self.backgroundColor = UIColor.clear
    }
    
    func drawLine(rect:CGRect) {
        let line = UIGraphicsGetCurrentContext()
        line?.setLineWidth(thickness)
        line?.setStrokeColor((lineColor).cgColor)
        line?.stroke(rect)
    }

}
