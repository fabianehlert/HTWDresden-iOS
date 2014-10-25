//
//  MPMainModel.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPMainModel: NSObject, NSXMLParserDelegate {
    
    var mensenTitel = [String]()
    var mensen = [String:[Speise]]()
    
    var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    override init() {
        super.init()
        
    }
    
    init(test: Bool) {
        super.init()
        let request = NSFetchRequest(entityName: "Speise")
        let array = context.executeFetchRequest(request, error: nil) as [Speise]
        //        dump(array)
    }
    
    func start(completion: () -> Void) {
        if MENSA_LAST_REFRESH != nil && MENSA_LAST_REFRESH.timeIntervalSinceNow >= -60*60 {
            // Wurde vor einer Stunde das letzte Mal aktualisiert
            self.getData()
            completion()
            return
        }
        let parser = MPMainXMLParser()
        parser.parseWithCompletion {
            success, error in
            if error != nil || !success {
                println("Parsen fehlgeschlagen")
                return
            }
            self.getData()
            completion()
        }
    }
    
    func refresh(start: () -> Void, end: () -> Void) {
        mensen = [String:[Speise]]()
        start()
        let parser = MPMainXMLParser()
        parser.parseWithCompletion {
            success, error in
            if error != nil || !success {
                println("Parsen fehlgeschlagen")
                return
            }
            self.getData()
            end()
        }
    }
    
    
    func getData() {
        mensen = [String:[Speise]]()
        let request = NSFetchRequest(entityName: "Speise")
        let array = context.executeFetchRequest(request, error: nil) as [Speise]
        for speise in array {
            if mensen[speise.mensa] == nil {
                mensen[speise.mensa] = [Speise]()
                if !contains(mensenTitel, speise.mensa) {
                    mensenTitel.append(speise.mensa)
                }
            }
            mensen[speise.mensa]?.append(speise)
        }
    }
    
    private var indexPath = NSIndexPath()
    private var imagesHandler: ((indexPath: NSIndexPath) -> Void)!
    func getImages(handler: (indexPath: NSIndexPath) -> Void) {
        imagesHandler = handler
        dispatch_async(DIFF_QUEUE) {
            for var i = 0; i < self.numberOfRowsInSection(0); i++ {
                self.indexPath = NSIndexPath(forRow: i, inSection: 0)
                if self.speiseForIndexPath(self.indexPath)?.bild != nil {
                    return
                }
                
                setNetworkIndicator(true)
                var request = NSURLRequest(URL: NSURL(string: self.speiseForIndexPath(self.indexPath)!.link)!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    response, data, error in
                    if data == nil {
                        self.speiseForIndexPath(self.indexPath)?.bild = nil
                    }
                    dispatch_async(DIFF_QUEUE) {
                        setNetworkIndicator(false)
                        let html: String = NSString(data: data, encoding: NSUTF8StringEncoding)!
                        let start = html.indexOf("<div id=\"spalterechtsnebenmenue\">")
                        var dataAfterHtml = html.subString(start, length: html.lengthAfterIndex(start))
                        dataAfterHtml = dataAfterHtml.subString(0, length: dataAfterHtml.indexOf("<div id=\"speiseplaninfos\">"))
                        dataAfterHtml.replace("&", withString: " und")
                        dataAfterHtml += "</div>"
                        
                        let parser = NSXMLParser(data: dataAfterHtml.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
                        parser.delegate = self
                        parser.parse()
                    }
                })
            }
        }
    }
    
    // MARK: - XMLParserDelegate
    var inEssenBild = false
    func parser(parser: NSXMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        let attributes = attributeDict as? [String: String]
        if elementName == "div" && attributes != nil && attributes?["id"] != nil && attributes?["id"]! == "essenbild" {
            inEssenBild = true
        }
        if elementName == "a" && inEssenBild {
            loadImageFromURL(attributes!["href"])
            parser.abortParsing()
        }
    }
    
    func loadImageFromURL(string: String?) {
        if string == nil {
            println("Kein Bild gefunden..")
            return
        }
        let image = UIImage(data: NSData(contentsOfURL: NSURL(string: string!)!)!)
//        dump(image)
        if speiseForIndexPath(self.indexPath) != nil { speiseForIndexPath(self.indexPath)!.bild = UIImagePNGRepresentation(image) }
        dispatch_async(MAIN_QUEUE) {
            self.imagesHandler(indexPath: self.indexPath)
            (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext?.save(nil)
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if CURR_MENSA != nil {
            return mensen[CURR_MENSA]?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    func speiseForIndexPath(indexPath: NSIndexPath) -> Speise? {
        if let thisMensa = mensen[CURR_MENSA] {
            return thisMensa[indexPath.row]
        }
        return nil
    }
   
}
