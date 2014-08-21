//
//  SPPortraitModel.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import Foundation
import UIKit

class SPPortraitModel {

    var user: User!
    var stunden: [[String:Stunde]]!
    
    var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    init(matrnr: String) {
        var getUser = userByMatrnr(matrnr)
        if getUser.exists {
            user = getUser.user
            stunden = [[String:Stunde]]()
            for stunde in user.stunden.allObjects as [Stunde] {
                stunden.append([stunde.ident:stunde])
            }
            println("== User \(user.matrnr) erfolgreich geladen")
        }
        else {
            user = nil
            let parser = SPXMLParser(kennung: matrnr, raum: false)
            parser.parseWithCompletion {
                success, error in
                if success {
                    println("== Stunden erfolgreich geladen.")
                    self.user = self.userByMatrnr(matrnr).user
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
