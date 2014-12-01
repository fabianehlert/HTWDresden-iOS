//
//  SPPortaitVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit


class SPPortaitVC: UIViewController, UIScrollViewDelegate, UIActionSheetDelegate, SPPortraitDelegate, SPPortraitDetailPhoneDelegate, SPPortraitDetailPadDelegate {
    
    private let PixelPerMin: CGFloat = 0.5
    
    @IBOutlet weak var scrollView: UIScrollView!
    var model: SPPortraitModel!
    let myAlert = HTWAlert()
    var buttons = [SPButtonLesson]()
    var selectedButton: SPButtonLesson?
    var currentDate = NSDate()
    
    // MARK: - UI Elemente
    var tageView: UIView!
    var zeitenView: UIView!
    var panView: UIView! // für das SideMenu als "Anker"
    
    // MARK: - Detail (iPad)
    var detailView: SPPortraitDetailPad?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        
        panView = UIView(frame: CGRect(x: 0, y: -350, width: 40, height: view.frame.size.height+700))
        view.addSubview(panView)
        
        var sideBarButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Bordered, target: self.revealViewController(), action: Selector("revealToggle:"))
        navigationItem.leftBarButtonItem = sideBarButton
        panView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if device() == .Pad {
            detailView = SPPortraitDetailPad(frame: CGRect(x: 0, y: view.frame.size.height/2 - 70, width: view.frame.size.width, height: view.frame.size.height/2))
            detailView!.stunde = nil
            detailView!.delegate = self
            scrollView.addSubview(detailView!)
        }
        
        title = "Stunden"
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if device() == .Phone {
            selectedButton?.select = false
            selectedButton = nil
        }
        view.bringSubviewToFront(panView)
    }
    
    // MARK: - SPDetailDelegates
    func SPPortraitModelfinishedLoading(model: SPPortraitModel) {
        self.getButtons()
    }
    
    func SPPortraitDetailPhoneDeletedStundeAtIndex(index: Int) {
        (buttons[index] as SPButtonLesson).removeFromSuperview()
        buttons.removeAtIndex(index)
    }
    
    func SPPortraitDetailPhoneChangedStundeAtIndex(index: Int) {
        buttons[index].stunde = model.refreshStunde(buttons[index].stunde)
    }
    
    func SPDetailPadChangedStundeAtIndex(index: Int) {
        buttons[index].stunde = model.refreshStunde(buttons[index].stunde)
    }
    
    // MARK: - set up the Interface
    func getButtons() {
        
        for stunde in self.model.stunden {
            let button = SPButtonLesson(stunde: stunde, portrait: true, currentDate: currentDate)
            button.tapHandler = buttonHandler
            if button.isNow() {
                button.now = true
                selectedButton = button
                detailView?.stunde = selectedButton?.stunde
                if detailView != nil { scrollView.bringSubviewToFront(detailView!) }
            }
            if device() == .Pad {
                let longPress = UILongPressGestureRecognizer(target: self, action: "deleteOniPad:")
                longPress.minimumPressDuration = 0.5
                button.addGestureRecognizer(longPress)
            }
            buttons += [button]
            dispatch_async(MAIN_QUEUE) {
                self.scrollView.addSubview(button)
            }
        }
        
        if device() == .Pad { self.view.bringSubviewToFront(self.detailView!) }
    }
    
    func buttonHandler(button: SPButtonLesson) {
        self.selectedButton?.select = false
        self.selectedButton = button
        button.select = true
        
        
        if device() == .Phone {
            self.performSegueWithIdentifier("detailPhone", sender: button)
        }
        else if device() == .Pad {
            self.detailView?.stunde = button.stunde
            self.detailView?.index = find(self.buttons,button)!
            self.scrollView.bringSubviewToFront(self.detailView!)
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
    
    // MARK: - Actions
    func deleteOniPad(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let senderButton = sender.view as SPButtonLesson
            // TODO: - Unvollständig
            let alert = UIAlertController(title: "Warnung", message: "Wollen sie die Stunde \(senderButton.stunde.titel) wirklich löschen?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ja", style: .Default, handler: {
                action in
                let index = find(self.buttons, senderButton)
                self.model.deleteStunde(senderButton.stunde)
                self.SPPortraitDetailPhoneDeletedStundeAtIndex(index!)
            }))
            alert.addAction(UIAlertAction(title: "Nein", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
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
        view.bringSubviewToFront(panView)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        switch segue.identifier! {
        case "detailPhone":
            let title = (sender as SPButtonLesson).stunde.titel
            println("detailPhone \(title)")
            (segue.destinationViewController as SPPortraitDetailPhoneTVC).stunde = (sender as SPButtonLesson).stunde
            (segue.destinationViewController as SPPortraitDetailPhoneTVC).index = find(buttons, sender as SPButtonLesson)
            (segue.destinationViewController as SPPortraitDetailPhoneTVC).delegate = self
        default:
            break
        }
    }
    
    // MARK: - Hilfsfunktionen
    
    
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

    

    
