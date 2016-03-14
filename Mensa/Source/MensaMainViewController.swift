//
//  MensaMainViewController.swift
//  Pods
//
//  Created by Benjamin Herzog on 04/03/16.
//
//

import UIKit
import Core

let getMensa = "http://www.studentenwerk-dresden.de/feeds/speiseplan.rss"

class MensaMainViewController: Core.ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let p: Parser = Parser.init(strPath: getMensa)
        print(p.loadData())
    }
}

class Parser: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var strPath: String = ""
    var strTitle: String = ""
    var strDescription: String = ""
    var strMensa: String = ""
    var strCostStudent: String = ""
    var strCostOther: String = ""
    var bParseTitle: Bool = false
    var bParseDescription: Bool = false
    var bParseMensa: Bool = false
    var MealData: [MealData_t] = [MealData_t]()
    
    override init() {
        super.init()
    }
    
    init(strPath: String) {
        self.strPath = strPath
    }
    
    func loadData () -> [MealData_t] {
        let url: NSURL = NSURL(string: strPath)!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        let success: Bool = parser.parse()
        
        if success {
            print("Parsing war erfolgreich!")
        }
        else {
            print("Fehler beim Parsen der Mensadaten!")
        }
        return MealData
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "title" {
            bParseTitle = true
        }
        else if elementName == "description" {
            bParseDescription = true
        }
        else if elementName == "author" {
            bParseMensa = true
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title" {
            bParseTitle = false
        }
        else if elementName == "description" {
            bParseDescription = false
        }
        else if elementName == "author" {
            bParseMensa = false
            let startRange1 = self.strDescription.rangeOfString("(Studierende: ")
            let endRange1 = self.strDescription.rangeOfString("EUR")
            let startRange2 = self.strDescription.rangeOfString("/ Bedienstete: ")
            let endRange2 = self.strDescription.rangeOfString("EUR)")
            if startRange1 != nil {
                var intIndex: Int = self.strDescription.startIndex.distanceTo(startRange1!.startIndex)
                let startIndex = self.strDescription.startIndex.advancedBy(intIndex + (startRange1?.count)!)
                intIndex = self.strDescription.startIndex.distanceTo(endRange1!.startIndex)
                let endIndex = self.strDescription.startIndex.advancedBy(intIndex - 2)
                let range2 = startIndex...endIndex
                strCostStudent = self.strDescription[range2]
                strCostStudent.appendContentsOf("€")
            }
            if startRange2 != nil {
                var intIndex: Int = self.strDescription.startIndex.distanceTo(startRange2!.startIndex)
                let startIndex = self.strDescription.startIndex.advancedBy(intIndex + (startRange2?.count)!)
                intIndex = self.strDescription.startIndex.distanceTo(endRange2!.startIndex)
                let endIndex = self.strDescription.startIndex.advancedBy(intIndex - 2)
                let range2 = startIndex...endIndex
                strCostOther = self.strDescription[range2]
                strCostOther.appendContentsOf("€")
            }
            MealData.append(MealData_t(strTitle: self.strTitle, strDescription: self.strDescription, strMensa: self.strMensa, strCostStudent: self.strCostStudent, strCostOther: self.strCostOther))
            self.strTitle.removeAll()
            self.strDescription.removeAll()
            self.strMensa.removeAll()
            self.strCostStudent.removeAll()
            self.strCostOther.removeAll()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if bParseTitle {
            self.strTitle.appendContentsOf(string)
        }
        else if bParseDescription {
            self.strDescription.appendContentsOf(string)
        }
        else if bParseMensa {
            self.strMensa.appendContentsOf(string)
        }
    }
    
    struct MealData_t {
        var strTitle: String
        var strDescription: String
        var strMensa: String
        var strCostStudent: String
        var strCostOther: String
    }
}
