//
//  GlobalExtensions.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func containsIgnoreCase(other: String) -> Bool{
        var start = startIndex

        do{
            var subString = self[Range(start: start++, end: endIndex)].lowercaseString
            if subString.hasPrefix(other.lowercaseString){
                return true
            }

        }while start != endIndex

        return false
    }

    func lengthAfterIndex(index: Int) -> Int {
        return self.length - index
    }
    
}

extension String
{
    var length: Int {
        get {
            return countElements(self)
        }
    }
    
    func contains(s: String) -> Bool
    {
        return (self.rangeOfString(s) != nil) ? true : false
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> Character
    {
        get {
            let index = advance(startIndex, i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String
    {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(self.startIndex, r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func subString(startIndex: Int, length: Int) -> String
    {
        var start = advance(self.startIndex, startIndex)
        var end = advance(self.startIndex, startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    func indexOf(target: String) -> Int
    {
        var range = self.rangeOfString(target)
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int
    {
        var startRange = advance(self.startIndex, startIndex)
        
        var range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
        var error: NSError?
        var exp = NSRegularExpression(pattern: regex, options: options, error: &error)!
        
        if let error = error {
            println(error.description)
        }
        var matchCount = exp.numberOfMatchesInString(self, options: nil, range: NSMakeRange(0, self.length))
        return matchCount > 0
    }
    
    func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]
    {
        var error: NSError?
        var exp = NSRegularExpression(pattern: regex, options: options, error: &error)!
        
        if let error = error {
            println(error.description)
        }
        var matches = exp.matchesInString(self, options: nil, range: NSMakeRange(0, self.length))
        return matches as [NSTextCheckingResult]
    }
    
    private var vowels: [String]
    {
      get
      {
        return ["a", "e", "i", "o", "u"]
      }
    }
    
    private var consonants: [String]
    {
      get
      {
        return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
      }
    }
    
    func pluralize(count: Int) -> String
    {
        if count == 1 {
            return self
        } else {
            var lastChar = self.subString(self.length - 1, length: 1)
            var secondToLastChar = self.subString(self.length - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercaseString == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                prefix = self[0...self.length - 1]
                suffix = "ies"
            } else if lastChar.lowercaseString == "s" || (lastChar.lowercaseString == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                prefix = self[0...self.length]
                suffix = "es"
            } else {
                prefix = self[0...self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercaseString ? suffix : suffix.uppercaseString)
        }
    }
}

extension NSDate {
    
    class func dateFromString(string: String, format: String) -> NSDate {
        let dateF = NSDateFormatter()
        dateF.dateFormat = format
        return dateF.dateFromString(string)!
    }

    func stringFromDate(format: String) -> String {
        let dateF = NSDateFormatter()
        dateF.dateFormat = format
        return dateF.stringFromDate(self)
    }

    class func weekDay() -> Int {
        var weekday = (NSCalendar.currentCalendar().components(.WeekdayCalendarUnit, fromDate: NSDate())).weekday - 2
        if weekday == -1 {
            weekday = 6
        }
        return weekday
    }

    func weekDay() -> Int {
        var weekday = (NSCalendar.currentCalendar().components(.WeekdayCalendarUnit, fromDate: self)).weekday - 2
        if weekday == -1 {
            weekday = 6
        }
        return weekday
    }

    func weekdayString() -> String {
        switch self.weekDay() {
            case 0: return "Montag"
            case 1: return "Dienstag"
            case 2: return "Mittwoch"
            case 3: return "Donnerstag"
            case 4: return "Freitag"
            case 5: return "Samstag"
            case 6: return "Sonntag"
                
            default: return ""
        }
    }

    func getDayOnly() -> NSDate {
        let dateF = NSDateFormatter()
        dateF.dateFormat = "dd.MM.yyyy"
        return dateF.dateFromString(dateF.stringFromDate(self))!
    }
    
    class func isSameDayWithDate1(date1: NSDate, andDate2 date2: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let comp1 = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date1)
        let comp2 = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date2)
        return comp1.day == comp2.day && comp1.month == comp2.month && comp1.year == comp2.year
    }

    class func specificDate(day: Int, month: Int, year: Int) -> NSDate {
        var comps = NSDateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        return NSCalendar.currentCalendar().dateFromComponents(comps)!
    }

    func inRange(date1: NSDate, date2: NSDate) -> Bool {
        if NSCalendar.currentCalendar().compareDate(self, toDate: date1, toUnitGranularity: .HourCalendarUnit) == NSComparisonResult.OrderedAscending {
            return false
        }
        if NSCalendar.currentCalendar().compareDate(self, toDate: date2, toUnitGranularity: .HourCalendarUnit) == NSComparisonResult.OrderedDescending {
            return false
        }
        return true
    }

    func addDays(days: Int) -> NSDate {
        var dayComponent = NSDateComponents()
        dayComponent.day = days
        var theCalendar = NSCalendar.currentCalendar()
        return theCalendar.dateByAddingComponents(dayComponent, toDate: self, options: .allZeros)!
    }
}

extension UIColor {
	
	class func HTWBlueColor() -> UIColor {
		return UIColor(red: 58.0/255.0, green: 121.0/255.0, blue: 162.0/255.0, alpha: 1)
	}

	class func HTWRedColor() -> UIColor {
		return UIColor(red: 197.0/255.0, green: 79.0/255.0, blue: 52.0/255.0, alpha: 1)
	}

	class func HTWDarkGrayColor() -> UIColor {
		return UIColor(red: 115.0/255.0, green: 113.0/255.0, blue: 111.0/255.0, alpha: 1)
	}

	class func HTWGrayColor() -> UIColor {
		return UIColor(red: 181.0/255.0, green: 178.0/255.0, blue: 175.0/255.0, alpha: 1)
	}

	class func HTWSandColor() -> UIColor {
		return UIColor(red: 247.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1)
	}

	class func HTWWhiteColor() -> UIColor {
		return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
	}

	class func HTWDarkBlueColor() -> UIColor {
		return UIColor(red: 65.0/255.0, green: 104.0/255.0, blue: 111.0/255.0, alpha: 1)
	}

	class func HTWGreenColor() -> UIColor {
		return UIColor(red: 115.0/255.0, green: 145.0/255.0, blue: 51.0/255.0, alpha: 1)
	}

	class func HTWBackgroundColor() -> UIColor {
		return HTWSandColor()
	}

	class func HTWTextColor() -> UIColor {
		return HTWDarkGrayColor()
	}

	class func HTWTextInactiveColor() -> UIColor {
		return HTWGrayColor()
	}

}



extension UIFont {
    
    class func systemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PTSans-Regular", size: fontSize)!
    }

    class func boldSystemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PTSans-Bold", size: fontSize)!
    }

    class func italicSystemFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PTSans-Italic", size: fontSize)!
    }

    class func HTWExtraLargeFont() -> UIFont {
        return UIFont(name: "PT Sans", size: 25)!
    }
    class func HTWLargeFont() -> UIFont {
        return UIFont(name: "PT Sans", size: 21)!
    }
    class func HTWBaseFont() -> UIFont {
        return UIFont(name: "PT Sans", size: 17)!
    }
    class func HTWSmallFont() -> UIFont {
        return UIFont(name: "PT Sans", size: 14)!
    }
    class func HTWVerySmallFont() -> UIFont {
        return UIFont(name: "PT Sans", size: 12)!
    }
    class func HTWSmallestFont() -> UIFont {
        return UIFont(name: "PT Sans", size: 10)!
    }

    class func HTWSmallBoldFont() -> UIFont {
        return UIFont(name: "PT Sans Bold", size: 14)!
    }
    class func HTWBaseBoldFont() -> UIFont {
        return UIFont(name: "PT Sans Bold", size: 17)!
    }
    class func HTWLargeBoldFont() -> UIFont {
        return UIFont(name: "PT Sans Bold", size: 21)!
    }

    class func HTWSmallItalicFont() -> UIFont {
        return UIFont(name: "PT Sans Italic", size: 14)!
    }
    class func HTWBaseItalicFont() -> UIFont {
        return UIFont(name: "PT Sans Italic", size: 17)!
    }
    class func HTWLargeItalicFont() -> UIFont {
        return UIFont(name: "PT Sans Italic", size: 21)!
    }

    class func HTWSmallItalicBoldFont() -> UIFont {
    	return UIFont(name: "PT Sans Bold Italic", size: 14)!
    }

    class func HTWTableViewCellFont() -> UIFont {
    	return HTWBaseFont()
    }
}