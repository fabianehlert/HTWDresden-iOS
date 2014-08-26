//
//  SPPortraitModel.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation
import UIKit

protocol SPPortraitDelegate {
    
    func SPPortraitModelfinishedLoading(model: SPPortraitModel)
    
}


class SPPortraitModel: NSObject {

    var delegate: SPPortraitDelegate?
    
    var user: User!
    var stunden: [Stunde]!
    
    var matrnr: String
    var currentDate: NSDate
    
    
    var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    // MARK: - Initialiser
    init(matrnr: String, currentDate: NSDate, delegate: SPPortraitDelegate?) {
        
        self.matrnr = matrnr
        self.currentDate = currentDate
        self.delegate = delegate
        super.init()
    }
    
    func start() {
        var getUser = userByMatrnr(matrnr)
        if getUser.exists {
            user = getUser.user
            stunden = [Stunde]()
            for stunde in user.stunden.allObjects as [Stunde] {
                if stunde.anfang.inRange(currentDate.getDayOnly(), date2: currentDate.getDayOnly().addDays(ANZ_PORTRAIT)) {
//                    println("Stunde \(stunde.titel) Anfang: \(stunde.anfang) ist im Bereich \(self.currentDate.getDayOnly()) bis \(self.currentDate.getDayOnly().addDays(ANZ_PORTRAIT))")
                    stunden.append(stunde)
                }
                
            }
            println("== User \(user.matrnr) erfolgreich geladen")
            self.delegate?.SPPortraitModelfinishedLoading(self)
        }
        else {
            user = nil
            let parser = SPXMLParser(kennung: matrnr, raum: false)
            parser.parseWithCompletion {
                success, error in
                if success {
                    println("== Stunden erfolgreich geladen.")
                    self.user = self.userByMatrnr(self.matrnr).user
                    self.stunden = [Stunde]()
                    for stunde in self.user.stunden.allObjects as [Stunde] {
                        if stunde.anfang.inRange(self.currentDate.getDayOnly(), date2: self.currentDate.getDayOnly().addDays(ANZ_PORTRAIT)) {
//                            println("Stunde \(stunde.titel) Anfang: \(stunde.anfang) ist im Bereich \(self.currentDate.getDayOnly()) bis \(self.currentDate.getDayOnly().addDays(ANZ_PORTRAIT))")
                            self.stunden.append(stunde)
                        }
                    }
                    println("== User \(self.user.matrnr) erfolgreich geladen")
                    self.delegate?.SPPortraitModelfinishedLoading(self)
                }
            }
        }
    }
    
    func reloadStunden() {
        let parser = SPXMLParser(kennung: user.matrnr, raum: false)
        parser.parseWithCompletion {
            success, error in
            if success {
                println("== Stunden erfolgreich aktualisiert")
                self.user = self.userByMatrnr(self.user.matrnr).user
            }
        }
    }
    
    func refreshStunde(stunde: Stunde, titel: String, kuerzel: String, dozent: String, bemerkungen: String) {
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde.ident, stunde.student.matrnr, stunde.anfang)
        let tempArray = context.executeFetchRequest(request, error: nil)
        dump(tempArray)
    }
    
    // DB-request for getting the current user
    func userByMatrnr(matrnr: String) -> (exists: Bool, user: User!) {
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "matrnr = %@", matrnr)
        var error: NSError?
        let result = context.executeFetchRequest(request, error: &error) as [User]
        if error != nil || result.count != 1 {
            return (false, nil)
        }
        else {
            let user = result[0]
            return (true, user)
        }
    }
    
}
