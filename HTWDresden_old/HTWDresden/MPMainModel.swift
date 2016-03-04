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
    
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    override init() {
        super.init()
        
    }
    
    init(test: Bool) {
        super.init()
        let request = NSFetchRequest(entityName: "Speise")
        let array = context.executeFetchRequest(request, error: nil) as [Speise]
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
