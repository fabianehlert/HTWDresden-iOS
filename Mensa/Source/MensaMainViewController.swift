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
            MealData.append(MealData_t(strTitle: self.strTitle, strDescription: self.strDescription, strMensa: self.strMensa))
            self.strTitle.removeAll()
            self.strDescription.removeAll()
            self.strMensa.removeAll()
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
    }
}
