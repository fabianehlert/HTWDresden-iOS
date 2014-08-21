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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CURR_MATRNR == nil {
            
            let alert = UIAlertController(title: "Willkommen", message: "Bitte geben Sie Ihre Kennung ein!", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler {
                textField in
                textField.textAlignment = .Center
            }
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            action in
                let kennung = (alert.textFields[0] as UITextField).text
                CURR_MATRNR = kennung
                self.model = SPPortraitModel(matrnr: kennung)
            }))
            
            presentViewController(alert, animated: true, completion: nil)
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
