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
    var buttons = [SPButtonLesson]()
    
    // MARK: - ViewController Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Noch nie angemeldet
        if CURR_MATRNR == nil {
            myAlert.alertInViewController(self, title: "Willkommen", message: "Bitte geben Sie Ihre Kennung ein!", numberOfTextFields: 1, actions: [(title: "Ok",{
                let kennung = self.myAlert.stringFromTextFieldAt(0)!
                CURR_MATRNR = kennung
                self.model = SPPortraitModel(matrnr: kennung, currentDate: NSDate.specificDate(21, month: 04, year: 2014)) {
                    self.getButtons()
                }
                
            }), (title: "Abbrechen", action: nil)])
        }
        // aktueller Nutzer existiert
        else {
            // Model lädt aus DB oder (falls nicht vorhanden), lädt neu herunter
            self.model = SPPortraitModel(matrnr: CURR_MATRNR!, currentDate: NSDate.specificDate(21, month: 04, year: 2014)) {
                self.getButtons()
            }
        }
        self.model.start()

    }
    
    // MARK: - get Buttons via Model
    func getButtons() {
        scrollView.contentSize = CGSize(width: CGFloat(60+116*ANZ_PORTRAIT), height: CGFloat(459 + UINavigationBar.appearance().frame.size.height))
        scrollView.directionalLockEnabled = true
        
        
        for stunde in self.model.stunden {
            let button = SPButtonLesson(stunde: stunde, portrait: true, currentDate: NSDate.specificDate(21, month: 04, year: 2014))
            buttons += [button]
            scrollView.addSubview(button)
        }
    }
    
    // MARK: - NOT IN FINAL RELEASE
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

    

    
