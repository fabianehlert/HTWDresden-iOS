//
//  SPXMLParser.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation
import UIKit

class SPXMLParser: NSObject, NSXMLParserDelegate {

    var kennung: String
    var name: String?
    var raum: Bool
    
    var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    var newUser: User!
    
    var completion: ((success: Bool, error: String!) -> Void)!
    
    // Parser-Propertys
    var inStunde = false
    var currentItem: String!
    var stundeDic: [String:String]!
    
    // MARK: - Initialisers
    init(kennung: String, raum: Bool) {
        self.kennung = kennung
        self.raum = raum
    }
    
    // MARK: - Start the Parser
    func parseWithCompletion(handler: (success: Bool, error: String!) -> Void ) -> Void {
        completion = handler
        
        println("== Lade Daten von \(kennung)")
        
        let requestString = "matr=\(kennung)&pressme=S+T+A+R+T"
        let requestData = NSData(bytes: (requestString as NSString).UTF8String, length: requestString.length)
        var request = NSMutableURLRequest(URL: NSURL(string: XML_PARSER_URL), cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 10)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.HTTPBody = requestData
        
        setNetworkIndicator(true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            if data == nil {
                self.completion(success: false, error: "Verbindung fehlgeschlagen.")
                return
            }
            
            var html: String = NSString(data: data, encoding: NSASCIIStringEncoding)
            if html.contains("Stundenplan im csv-Format erstellen") || html.contains("Es wurden keine Daten gefunden") {
                self.completion(success: false, error: "Falsche Kennung")
            }
            
            // Aktuelles Semester
            dispatch_async(DIFF_QUEUE) {
                let htmlForSemester: String = NSString(contentsOfURL: NSURL(string:"http://www2.htw-dresden.de/~rawa/cgi-bin/auf/raiplan_app.php"), encoding: NSASCIIStringEncoding, error: nil)
                setNetworkIndicator(false)
                let index = htmlForSemester.indexOf("<h2>")
                var semester = htmlForSemester[index + "<h2>".length...index + 50]
                
                let teile = semester.componentsSeparatedByString(" ")
                semester = NSString(format: "%@ %@", teile[0], teile[1])
                
                CURR_SEMESTER = semester
                
                let startIndex = html.indexOf("<Stunde")
                var dataAfterHtml = html.subString(startIndex, length: html.lengthAfterIndex(startIndex))
                dataAfterHtml = dataAfterHtml.subString(0, length: dataAfterHtml.indexOf("<br>"))
                var formattedXML = "<data>\(dataAfterHtml)</data>"
                formattedXML.replace("&", withString: " und ")
                
                var retData = formattedXML.dataUsingEncoding(NSUTF8StringEncoding)!
                
                var parser = NSXMLParser(data: retData)
                parser.delegate = self
                parser.parse()
            }
        })
    }
    
    // MARK: - Parser Delegates
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError!) {
        completion(success: false, error: parseError.localizedDescription)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        switch elementName {
        case "data":
            newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as User
            newUser.matrnr = "\(kennung)+temp"
            newUser.letzteAktualisierung = NSDate()
            newUser.raum = NSNumber(bool: raum)
            if name != nil {
                newUser.name = name
            }
            context.save(nil)
        case "Stunde":
            inStunde = true
            stundeDic = [String:String]()
        default:
            break
        }
        currentItem = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String!) {
        if inStunde {
            if let temp = stundeDic[currentItem] {
                var tempString = temp
                tempString += string
                stundeDic[currentItem] = tempString
            }
            else {
                stundeDic[currentItem] = string
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        switch elementName {
        case "data":
            context.save(nil)
            var request = NSFetchRequest()
            request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
            request.predicate = NSPredicate(format: "matrnr = %@", kennung)
            let oldObjects = context.executeFetchRequest(request, error: nil)
            if oldObjects.count == 0 {
                newUser.matrnr = newUser.matrnr.componentsSeparatedByString("+")[0]
                context.save(nil)
                let raumString = newUser.raum.boolValue ? "ja" : "nein"
                println("== Neuer Datensatz. Kennung: \(newUser.matrnr), Aktualisierung: \(newUser.letzteAktualisierung), Raum: \(raumString)")
            }
            else {
                println("== Nutzer vorhanden, Stunden werden aktualisiert")
                let oldUser = oldObjects[0] as User
                println("== Stunden vorher: \(oldUser.stunden.count)")
                for stunde in newUser.stunden.allObjects as [Stunde] {
                    if isStunde(stunde, inCollection: oldUser.stunden.allObjects as [Stunde]) {
                        continue
                    }
                    else {
                        oldUser.addStundenObject(stunde)
                    }
                }
                context.deleteObject(newUser)
                context.save(nil)
                println("== Stunden nachher: \(oldUser.stunden.count)")
            }
            break
        case "Stunde":
            var stunde = Stunde(entity: NSEntityDescription.entityForName("Stunde", inManagedObjectContext: context), insertIntoManagedObjectContext: context)
            stunde.titel = stundeDic["titel"]
            var tempKuerzel = stundeDic["kuerzel"]?.componentsSeparatedByString("/")[0]
            stunde.kurzel = tempKuerzel?.length >= 1 ? tempKuerzel?.subString(0, length: tempKuerzel!.length-1) : tempKuerzel
            stunde.raum = stundeDic["raum"]
            stunde.dozent = stundeDic["dozent"]
            let datum = stundeDic["datum"]!
            let anfangZeit = stundeDic["anfang"]!
            let endeZeit = stundeDic["ende"]!
            stunde.anfang = NSDate.dateFromString("\(datum) \(anfangZeit)", format: "dd.MM.yyyy HH:mm")
            stunde.ende = NSDate.dateFromString("\(datum) \(endeZeit)", format: "dd.MM.yyyy HH:mm")
            stunde.ident = "\(stunde.kurzel)\(stunde.anfang.weekDay())\(anfangZeit)"
            stunde.anzeigen = NSNumber(bool: true)
            stunde.semester = CURR_SEMESTER
            
            newUser.addStundenObject(stunde)
            context.save(nil)
            stundeDic.removeAll(keepCapacity: false)
            break
        default:
            break
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(MAIN_QUEUE) {
            self.completion(success: true, error: nil)
        }
    }
    
    func isStunde(stunde: Stunde, inCollection: [Stunde]) -> Bool {
        for temp in inCollection {
            if temp.ident == stunde.ident {
                return true
            }
        }
        return false
    }
}



















































