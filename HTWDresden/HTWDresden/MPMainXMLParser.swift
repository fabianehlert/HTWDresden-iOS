//
//  MPMainXMLParser.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPMainXMLParser: NSObject, NSXMLParserDelegate {
    
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    var completion: ((success: Bool, error: String!) -> Void)!
    
    // MARK: - XMLHelper
    var currentItem: String!
    var speiseDic: [String:String]!
    var inItem = false
    
    var newSpeise: Speise!
    
    override init() {
        super.init()
        let request = NSFetchRequest(entityName: "Speise")
        let tempArray = context.executeFetchRequest(request, error: nil) as [Speise]
        for speise in tempArray {
            context.deleteObject(speise)
        }
        context.save(nil)
    }
    
    func parseWithCompletion(handler: (success: Bool, error: String?) -> Void) {
        completion = handler
        println("== Lade Mensenfeed...")
        let request = NSURLRequest(URL: NSURL(string: MENSA_URL)!)
        setNetworkIndicator(true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            if data == nil {
                self.completion(success: false, error: "Verbindung fehlgeschlagen.")
                return
            }
            
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
        })
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError!) {
        completion(success: false, error: parseError.localizedDescription)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        if elementName == "item" {
            inItem = true
            newSpeise = NSEntityDescription.insertNewObjectForEntityForName("Speise", inManagedObjectContext: context) as Speise
            speiseDic = [String: String]()
        }
        currentItem = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String!) {
        if string == "\n" { return }
        if inItem {
            if let temp = speiseDic[currentItem] {
                var tempString = temp
                tempString += string
                speiseDic[currentItem] = tempString
            }
            else {
                speiseDic[currentItem] = string
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "item" {
            inItem = false
            newSpeise.title = speiseDic["title"]?.componentsSeparatedByString("(").first
            newSpeise.desc = speiseDic["description"]
            newSpeise.link = speiseDic["link"]
            newSpeise.mensa = speiseDic["author"]
            context.save(nil)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(MAIN_QUEUE) {
            setNetworkIndicator(false)
            MENSA_LAST_REFRESH = NSDate()
            self.completion(success: true, error: nil)
        }
    }

}
