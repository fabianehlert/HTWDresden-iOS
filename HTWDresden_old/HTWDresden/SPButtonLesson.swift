//
//  SPButtonLesson.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation
import UIKit

class SPButtonLesson: UIButton {
    
    private let CELL_CORNER_RADIUS = 0
    private let CELL_PADDING: CGFloat = 4
    
    private var portrait: Bool
    private var currentDate: NSDate
    var stunde: Stunde {
        didSet{
            kurzel?.text = stunde.kurzel
            raum?.text = stunde.raum
            if stunde.typ != nil {
                typ?.text = stunde.typ
            }
            if stunde.bemerkungen == nil || stunde.bemerkungen == "" {
                circle?.hidden = true
            }
            else {
                circle?.hidden = false
                if select || now {
                    circle?.backgroundColor = circle!.hidden ? UIColor.clearColor() :UIColor.HTWWhiteColor()
                }
                else {
                    circle?.backgroundColor = circle!.hidden ? UIColor.clearColor() :UIColor.HTWTextColor()
                }
            }
        }
    }
    
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    private var x: CGFloat = 0
    private var y: CGFloat = 0
    
    private var circle: UIView?
    
    private var PixelPerMin: CGFloat = 0.0
    
    var newGr: UITapGestureRecognizer?
    
    var tapHandler: ((sender: SPButtonLesson) -> Void)? {
        didSet {
            if newGr != nil {
                removeGestureRecognizer(newGr!)
            }
            newGr = UITapGestureRecognizer(target: self, action: "gestureRecognizerAction:")
            newGr?.numberOfTapsRequired = 1
            addGestureRecognizer(newGr!)
        }
    }
    
    func gestureRecognizerAction(sender: UIGestureRecognizer) {
        tapHandler?(sender: self)
    }
    
    // MARK: - UI
    
    var kurzel: UILabel?
    var raum: UILabel?
    var typ: UILabel?
    
    // MARK: - Initialisers
    
    init(stunde: Stunde, portrait: Bool, currentDate: NSDate) {
        self.stunde = stunde
        self.portrait = portrait
        self.currentDate = currentDate
        PixelPerMin = portrait ? 0.5 : 0.35
        super.init(frame: CGRectZero)
        self.frame = configure()
        farben()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() -> CGRect
    {
        var myFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        height = CGFloat(stunde.ende.timeIntervalSinceDate(stunde.anfang)) / CGFloat(60) * PixelPerMin
        width = portrait ? 108 : 90
        
        if portrait {
            let today = currentDate.getDayOnly()
            var dayComponent = NSDateComponents()
            dayComponent.day = 1
            var theCalendar = NSCalendar.currentCalendar()
            var tage = [NSDate]()
            tage.append(today)
            for var i = 1; i < ANZ_PORTRAIT; i++ {
                tage.append(theCalendar.dateByAddingComponents(dayComponent, toDate: tage[i-1], options: .allZeros)!)
            }
            for var i = 0; i < tage.count; i++ {
                if NSDate.isSameDayWithDate1(stunde.anfang, andDate2: tage[i]) {
                    x = CGFloat(50 + i *  116)
                    y = CGFloat(54 + CGFloat(stunde.anfang.timeIntervalSinceDate(tage[i].dateByAddingTimeInterval(60*60*7+60*30))) / 60 * PixelPerMin)
                    break
                }
            }
        }
        else {
            let weekday = self.currentDate.weekDay()
            var dayComponent = NSDateComponents()
            dayComponent.day = 1
            var threeDayComponent = NSDateComponents()
            threeDayComponent.day = 3
            var theCalendar = NSCalendar.currentCalendar()
            
            let montag = currentDate.getDayOnly().dateByAddingTimeInterval(NSTimeInterval(-60 * 60 * 24 * weekday))
            
            var tage = [NSDate]()
            
            var zaehler = 0
            for var i = 1; i < ANZ_LANDSCAPE; i++ {
                if zaehler < 4 {
                    tage.append(theCalendar.dateByAddingComponents(dayComponent, toDate: tage[i - 1], options: .allZeros)!)
                }
                else {
                    tage.append(theCalendar.dateByAddingComponents(threeDayComponent, toDate: tage[i - 1], options: .allZeros)!)
                }
                zaehler++
                if zaehler > 4 {
                    zaehler = 0
                }
            }
            for var i = 0; i < tage.count; i++ {
                if NSDate.isSameDayWithDate1(stunde.anfang, andDate2: tage[i]) {
                    x = 1
                    if i != 0 {
                        x = CGFloat(1 + i * 103 + 61 * UInt8(i/5))
                    }
                    y = CGFloat(45 + CGFloat(stunde.anfang.timeIntervalSinceDate(tage[i].dateByAddingTimeInterval(60*60*7+60*30))) / 60 * PixelPerMin)
                    break
                }
            }
        }
        
        myFrame = CGRect(x: x, y: y, width: width, height: height)
        
        return myFrame
    }
    
    func farben() {
        backgroundColor = UIColor.HTWWhiteColor()
        layer.cornerRadius = CGFloat(CELL_CORNER_RADIUS)
        
        kurzel = UILabel(frame: CGRect(x: x+CELL_PADDING, y: y, width: width*0.98, height: height*0.6))
        kurzel?.text = stunde.kurzel.componentsSeparatedByString(" ")[0]
        kurzel?.textAlignment = .Left
        kurzel?.textColor = UIColor.HTWDarkGrayColor()
        kurzel?.font = portrait ? UIFont.HTWLargeFont() : UIFont.HTWBaseFont()
        
        raum = UILabel(frame: CGRect(x: x+CELL_PADDING, y: y+(height*0.5), width: width*0.98, height: height*0.4))
        raum?.text = stunde.raum
        raum?.textAlignment = .Left
        raum?.textColor = UIColor.HTWGrayColor()
        raum?.font = portrait ? UIFont.HTWSmallFont() : UIFont.HTWSmallestFont()
        
        if stunde.typ != nil {
            typ = UILabel(frame: CGRect(x: x, y: y+(height*0.5), width: width-6, height: height*0.4))
            typ?.text = stunde.typ
            typ?.font = portrait ? UIFont.HTWSmallFont() : UIFont.HTWVerySmallFont()
            typ?.textAlignment = .Right
            typ?.textColor = UIColor.HTWGrayColor()
            addSubview(typ!)
        }
        
        circle = UIView()
        if portrait {
            circle?.frame = CGRect(x: x+(width*6/7)+2,y: y+3,width: 10,height: 10)
        }
        else {
            circle?.frame = CGRect(x: x+(width*6/7)+2,y: y+3,width: 7,height: 7)
        }
        circle?.hidden = true
        circle?.layer.cornerRadius = circle!.frame.size.height/2;
        self.addSubview(circle!)
        
        if stunde.bemerkungen != nil && stunde.bemerkungen != ""
        {
            // Bemerkung ist vorhanden, muss im Button bemerkbar sein..
            circle?.hidden = false
            circle?.backgroundColor = UIColor.HTWTextColor()
            circle?.tag = -9;
        }
        
        bounds = frame
        addSubview(kurzel!)
        addSubview(raum!)
    }
    
    // MARK: - Functions for the ViewController
    var now: Bool = false {
        didSet{
            if stunde.anzeigen.boolValue {
                backgroundColor = UIColor.HTWBlueColor()
                kurzel?.textColor = UIColor.HTWWhiteColor()
                raum?.textColor = UIColor.HTWWhiteColor()
                typ?.textColor = UIColor.HTWWhiteColor()
                circle?.backgroundColor = circle!.hidden ? UIColor.clearColor() : UIColor.HTWWhiteColor()
            }
        }
    }
    
    var select: Bool = false {
        didSet{
            if select {
                backgroundColor = UIColor.HTWBlueColor()
                kurzel?.textColor = UIColor.HTWWhiteColor()
                raum?.textColor = UIColor.HTWWhiteColor()
                typ?.textColor = UIColor.HTWWhiteColor()
                circle?.backgroundColor = circle!.hidden ? UIColor.clearColor() :UIColor.HTWWhiteColor()
            }
            else {
                backgroundColor = UIColor.HTWWhiteColor()
                kurzel?.textColor = UIColor.HTWDarkGrayColor()
                raum?.textColor = UIColor.HTWGrayColor()
                typ?.textColor = UIColor.HTWGrayColor()
                circle?.backgroundColor = circle!.hidden ? UIColor.clearColor() :UIColor.HTWTextColor()
            }
        }
    }
    
    func markLesson() {
        backgroundColor = UIColor.HTWBlueColor()
        
        for view in subviews {
            if view is UILabel {
                (view as! UILabel).textColor = UIColor.HTWWhiteColor()
            }
            else if view.tag == -9 {
                (view as! UIView).backgroundColor = UIColor.HTWWhiteColor()
            }
        }
    }
    
    func unmarkLesson() {
        backgroundColor = UIColor.HTWWhiteColor()
        kurzel?.textColor = UIColor.HTWDarkGrayColor()
        raum?.textColor = UIColor.HTWGrayColor()
        typ?.textColor = UIColor.HTWGrayColor()
        circle?.backgroundColor = circle!.hidden ? UIColor.clearColor() :UIColor.HTWTextColor()
    }
    
    func isNow() -> Bool {
        if NSDate().inRange(stunde.anfang, date2: stunde.ende) {
            return true
        }
        return false
    }
    
    
}
