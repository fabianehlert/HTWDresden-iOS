//
//  SPPortaitVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit


class SPPortaitVC: UIViewController, UIScrollViewDelegate, SPPortraitDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var model: SPPortraitModel!
    let myAlert = HTWAlert()
    var buttons = [SPButtonLesson]()
    var currentDate = NSDate()
    
    // MARK: - UI Elemente
    var tageView: UIView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = NSDate.specificDate(21, month: 04, year: 2014)
        
        title = "TEST"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.contentSize = CGSize(width: CGFloat(60+116*ANZ_PORTRAIT), height: CGFloat(459 + UINavigationBar.appearance().frame.size.height))
        scrollView.directionalLockEnabled = true
        scrollView.delegate = self
        loadDayLabels()
        
        // Noch nie angemeldet
        if CURR_MATRNR == nil {
            myAlert.alertInViewController(self, title: "Willkommen", message: "Bitte geben Sie Ihre Kennung ein!", numberOfTextFields: 1, actions: [(title: "Ok",{
                let kennung = self.myAlert.stringFromTextFieldAt(0)!
                CURR_MATRNR = kennung
                self.model = SPPortraitModel(matrnr: kennung, currentDate: self.currentDate, delegate: self)
                self.model.start()
            }), (title: "Abbrechen", action: nil)])
        }
        // aktueller Nutzer existiert
        else {
            // Model lädt aus DB oder (falls nicht vorhanden), lädt neu herunter
            self.model = SPPortraitModel(matrnr: CURR_MATRNR!, currentDate: currentDate, delegate: self)
            self.model.start()
        }

    }
    
    func SPPortraitModelfinishedLoading(model: SPPortraitModel) {
        getButtons()
    }
    
    // MARK: - set up the Interface
    func getButtons() {
        
        for stunde in self.model.stunden {
            let button = SPButtonLesson(stunde: stunde, portrait: true, currentDate: currentDate)
            buttons += [button]
            scrollView.addSubview(button)
        }
    }
    
    func loadDayLabels() {
        let wochentage = ["Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"]
        var wochentagePointer = currentDate.weekDay()
        
        var labels = [UILabel]()
        var cDate = currentDate.copy() as NSDate
        
        for var i: CGFloat = 0; i < CGFloat(ANZ_PORTRAIT); i++ {
            let x = CGFloat(i*116+50+scrollView.contentSize.width)
            var temp = UILabel(frame: CGRect(x: x, y: 13, width: 108, height: 26))
            temp.textAlignment = .Center
            temp.tag = -1
            temp.textColor = UIColor.HTWGrayColor()
            temp.font = UIFont.HTWVerySmallFont()
            temp.text = wochentage[wochentagePointer]
            
            var thisDate = UILabel(frame: CGRect(x: temp.frame.origin.x+temp.frame.size.width/4, y: temp.frame.origin.y-9, width: temp.frame.size.width/2, height: 15))
            thisDate.textAlignment = .Center
            thisDate.font = UIFont.HTWVerySmallFont()
            thisDate.tag = -1;
            thisDate.textColor = UIColor.HTWGrayColor()
            thisDate.text = cDate.stringFromDate("dd.MM.")
            
            wochentagePointer++
            if wochentagePointer > wochentage.count-1 {
                wochentagePointer = 0
            }
            cDate = cDate.dateByAddingTimeInterval(60*60*24)
            
            if i == 0 {
                temp.textColor = UIColor.HTWWhiteColor()
                thisDate.textColor = UIColor.HTWWhiteColor()
            }
            
            labels.append(temp)
            labels.append(thisDate)
        }
        
        tageView = UIView(frame: CGRect(x: -scrollView.contentSize.width, y: scrollView.contentOffset.y+64, width: scrollView.contentSize.width*3, height: 40))
        tageView.backgroundColor = UIColor.HTWDarkGrayColor()
        for label in labels {
            tageView.addSubview(label)
        }
        scrollView.addSubview(tageView)
    }
    
    func loadTimeLabels() {
        
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        orderViews(scrollView)
    }
    
    func orderViews(scrollView: UIScrollView) {
        tageView.frame = CGRect(x: -scrollView.contentSize.width, y: scrollView.contentOffset.y+64, width: scrollView.contentSize.width*3, height: 40)
        scrollView.bringSubviewToFront(tageView)
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

    

    
