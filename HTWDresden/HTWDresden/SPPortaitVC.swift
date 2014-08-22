//
//  SPPortaitVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit


class SPPortaitVC: UIViewController, UIScrollViewDelegate, SPPortraitDelegate {
    
    private let PixelPerMin: CGFloat = 0.5
    
    @IBOutlet weak var scrollView: UIScrollView!
    var model: SPPortraitModel!
    let myAlert = HTWAlert()
    var buttons = [SPButtonLesson]()
    var selectedButton: SPButtonLesson?
    var currentDate = NSDate.specificDate(21, month: 04, year: 2014)
    
    // MARK: - UI Elemente
    var tageView: UIView!
    var zeitenView: UIView!
    
    // MARK: - Detail (iPad)
    var detailView: SPPortraitDetailPad?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if device() == .Pad {
            detailView = SPPortraitDetailPad(frame: CGRect(x: 0, y: view.frame.size.height/2 - 70, width: view.frame.size.width, height: view.frame.size.height/2))
            detailView!.stunde = nil
            scrollView.addSubview(detailView!)
        }
        
        title = "Stunden"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: CGFloat(60+116*ANZ_PORTRAIT), height: CGFloat(459 + UINavigationBar.appearance().frame.size.height))
        scrollView.directionalLockEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.HTWSandColor()
        let gestureRec = UITapGestureRecognizer(target: self, action: "scrollScrollViewToToday")
        gestureRec.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(gestureRec)
        loadDayLabels()
        loadTimeLabels()
        
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
        dispatch_async(MAIN_QUEUE) {
            self.getButtons()
        }
    }
    
    // MARK: - set up the Interface
    func getButtons() {
        
        for stunde in self.model.stunden {
            let button = SPButtonLesson(stunde: stunde, portrait: true, currentDate: currentDate)
            button.tapHandler = {
                button in
                self.selectedButton?.select = false
                self.selectedButton = button
                button.select = true
                self.detailView?.stunde = button.stunde
            }
            if button.isNow() {
                button.now = true
                selectedButton = button
                detailView?.stunde = selectedButton?.stunde
                scrollView.bringSubviewToFront(detailView!)
            }
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
            temp.font = UIFont.HTWLargeFont()
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
        let today = currentDate.getDayOnly()
        zeitenView = UIView(frame: CGRect(x: scrollView.contentOffset.x, y: -350, width: 40, height: scrollView.frame.size.height+700))
        zeitenView.backgroundColor = UIColor.HTWDarkGrayColor()
        
        let vonStrings = ["07:30", "09:20", "11:10", "13:10", "15:00", "16:50", "18:30"]
        let bisStrings = ["09:00", "10:50", "12:40", "14:40", "16:30", "18:20", "20:00"]
        let stundenZeiten = [today.dateByAddingTimeInterval(60*60*7+60*30),
                            today.dateByAddingTimeInterval(60*60*9+60*20),
                            today.dateByAddingTimeInterval(60*60*11+60*10),
                            today.dateByAddingTimeInterval(60*60*13+60*10),
                            today.dateByAddingTimeInterval(60*60*15+60*00),
                            today.dateByAddingTimeInterval(60*60*16+60*50),
                            today.dateByAddingTimeInterval(60*60*18+60*30)]
        for var i = 0; i < stundenZeiten.count; i++ {
            let y = 54 + CGFloat(stundenZeiten[i].timeIntervalSinceDate(today.dateByAddingTimeInterval(7*60*60+30*60))) / 60 * PixelPerMin + 350
            let vonBisView = UIView(frame: CGRect(x: 5, y: y, width: 30, height: 90*PixelPerMin))
            let von = UILabel(frame: CGRect(x: 0, y: 0, width: vonBisView.frame.size.width, height: vonBisView.frame.size.height/2))
            von.text = vonStrings[i]
            von.font = UIFont.HTWVerySmallFont()
            von.textColor = UIColor.HTWWhiteColor()
            vonBisView.addSubview(von)
            let bis = UILabel(frame: CGRect(x: 0, y: vonBisView.frame.size.height/2, width: vonBisView.frame.size.width, height: vonBisView.frame.size.height/2))
            bis.text = bisStrings[i]
            bis.font = UIFont.HTWVerySmallFont()
            bis.textColor = UIColor.HTWWhiteColor()
            vonBisView.addSubview(bis)
            let strich = UIView(frame:CGRect(x: vonBisView.frame.size.width*0.25, y: von.frame.size.height, width: vonBisView.frame.size.width/2, height: 1))
            strich.backgroundColor = UIColor.HTWWhiteColor()
            vonBisView.addSubview(strich)
            
            zeitenView.addSubview(vonBisView)
        }
        
        scrollView.addSubview(zeitenView)
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        orderViews(scrollView)
    }
    
    func scrollScrollViewToToday() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
    }
    
    func orderViews(scrollView: UIScrollView) {
        zeitenView.frame = CGRect(x: scrollView.contentOffset.x, y: zeitenView.frame.origin.y, width: zeitenView.frame.size.width, height: zeitenView.frame.size.height)
        scrollView.bringSubviewToFront(zeitenView)
        tageView.frame = CGRect(x: -scrollView.contentSize.width, y: scrollView.contentOffset.y+64, width: scrollView.contentSize.width*3, height: 40)
        scrollView.bringSubviewToFront(tageView)
        
        if device() == .Pad {
            detailView?.frame.origin.x = scrollView.contentOffset.x
            scrollView.bringSubviewToFront(detailView!)
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

    

    
