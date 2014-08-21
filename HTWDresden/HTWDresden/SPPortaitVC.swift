//
//  SPPortaitVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit


class SPPortaitVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var model: SPPortraitModel!
    let myAlert = HTWAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CURR_MATRNR == nil {
            myAlert.alertInViewController(self, title: "Willkommen", message: "Bitte geben Sie Ihre Kennung ein!", numberOfTextFields: 1, actions: [(title: "Ok",{
                let kennung = self.myAlert.stringFromTextFieldAt(0)!
                CURR_MATRNR = kennung
                self.model = SPPortraitModel(matrnr: kennung)
            }), (title: "Abbrechen", action: nil)])
        }
        else {
            self.model = SPPortraitModel(matrnr: CURR_MATRNR!)
        }

    }
    
    func deleteAllInDB() {
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "User")
        let tempArray = context.executeFetchRequest(request, error: nil) as [User]
        for tempUser in tempArray {
            println("\(tempUser.matrnr) wird gelöscht...")
            context.deleteObject(tempUser)
        }
        let request2 = NSFetchRequest(entityName: "Stunde")
        let tempArray2 = context.executeFetchRequest(request2, error: nil) as [Stunde]
        for tempStunde in tempArray2 {
            println("Stunde \(tempStunde.titel) von Student wird gelöscht...")
            context.deleteObject(tempStunde)
        }
        context.save(nil)
    }
}
