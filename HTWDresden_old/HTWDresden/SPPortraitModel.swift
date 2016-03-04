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
    
//    var user: User!
    var stunden: [Stunde]!
    
    var matrnr: String
    var currentDate: NSDate
    
    
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
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
            self.stunden = self.getStundenFromUser(user, startDate: self.currentDate.getDayOnly(), endDate: self.currentDate.getDayOnly().addDays(ANZ_PORTRAIT))
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
                    user = self.userByMatrnr(self.matrnr).user
                    self.stunden = self.getStundenFromUser(user, startDate: self.currentDate.getDayOnly(), endDate: self.currentDate.getDayOnly().addDays(ANZ_PORTRAIT))
                    println("== User \(user.matrnr) erfolgreich geladen")
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
                user = self.userByMatrnr(user.matrnr).user
                self.stunden = self.getStundenFromUser(user, startDate: self.currentDate.getDayOnly(), endDate: self.currentDate.getDayOnly().addDays(ANZ_PORTRAIT))
            }
        }
    }
    
    func refreshStunde(stunde: Stunde) -> Stunde {
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde.ident, stunde.student.matrnr, stunde.anfang)
        let tempArray = context.executeFetchRequest(request, error: nil)
        return tempArray!.first as Stunde
    }
    
    func deleteStunde(stunde: Stunde) {
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde.ident, stunde.student.matrnr, stunde.anfang)
        let array = context.executeFetchRequest(request, error: nil)
        var tempStunde = array!.first as Stunde
        context.deleteObject(tempStunde)
        context.save(nil)
    }
    
    func getStundenFromUser(user: User, startDate: NSDate, endDate: NSDate) -> [Stunde] {
        var erg = [Stunde]()
        
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "student = %@ && anfang >= %@ && anfang <= %@", user, startDate, endDate)
        var error: NSError?
        let array = context.executeFetchRequest(request, error: &error)
        if error != nil || array?.count == 0 {
            return erg
        }
        
        return array as [Stunde]
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
