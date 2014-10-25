//
//  SPPortraitDetailPhoneTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 23.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

protocol SPPortraitDetailPhoneDelegate {
    
    func SPPortraitDetailPhoneDeletedStundeAtIndex(index: Int)
    func SPPortraitDetailPhoneChangedStundeAtIndex(index: Int)
}


class SPPortraitDetailPhoneTVC: UITableViewController, UITextViewDelegate {
    
    private let TEXT_FONT = UIFont.HTWBaseFont()
    private let VIEW_BACKGROUND = UIColor.HTWSandColor()
    private let CELL_BACKGROUND = UIColor.HTWWhiteColor()
    
    var delegate: SPPortraitDetailPhoneDelegate?
    
    var stunde: Stunde?
    var index: Int!
    
    @IBOutlet var bemerkungsCounter: UILabel!
    @IBOutlet weak var titelTextView: UITextView!
    @IBOutlet weak var kuerzelTextView: UITextView!
    @IBOutlet weak var raumTextView: UITextView!
    @IBOutlet weak var dozentTextView: UITextView!
    @IBOutlet weak var typTextView: UITextView!
    @IBOutlet weak var semesterTextView: UITextView!
    @IBOutlet weak var anfangTextView: UITextView!
    @IBOutlet weak var endeTextView: UITextView!
    @IBOutlet weak var bemerkungTextView: UITextView!
    
    @IBOutlet var labels: [UILabel]!
    
    
    lazy var myAlert = HTWAlert()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = VIEW_BACKGROUND
        view.backgroundColor = VIEW_BACKGROUND
        
        title = stunde?.kurzel
        
        titelTextView.text = stunde?.titel
        kuerzelTextView.text = stunde?.kurzel
        raumTextView.text = stunde?.raum
        dozentTextView.text = stunde?.dozent
        typTextView.text = stunde?.typ
        semesterTextView.text = stunde?.semester
        anfangTextView.text = formattedDate(stunde?.anfang)
        endeTextView.text = formattedDate(stunde?.ende)
        bemerkungTextView.text = stunde?.bemerkungen
        bemerkungsCounter.text = stunde?.bemerkungen != nil ? "\(stunde!.bemerkungen.length)/70" : "0/70"
        
        titelTextView.font = TEXT_FONT
        kuerzelTextView.font = TEXT_FONT
        raumTextView.font = TEXT_FONT
        dozentTextView.font = TEXT_FONT
        typTextView.font = TEXT_FONT
        semesterTextView.font = TEXT_FONT
        anfangTextView.font = TEXT_FONT
        endeTextView.font = TEXT_FONT
        bemerkungTextView.font = UIFont.HTWSmallFont()
        bemerkungsCounter.font = UIFont.HTWVerySmallFont()
        
        for label in labels {
            label.font = TEXT_FONT
        }
    }

    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0  {
            switch indexPath.row {
            case 0:
                titelTextView.becomeFirstResponder()
            case 1:
                kuerzelTextView.becomeFirstResponder()
            case 2:
                raumTextView.becomeFirstResponder()
            case 3:
                dozentTextView.becomeFirstResponder()
            case 4:
                typTextView.becomeFirstResponder()
            default: break
            }
        }
        else if indexPath.section == 1 {
            bemerkungTextView.becomeFirstResponder()
        }
        else if indexPath.section == 2 {
            myAlert.alertInViewController(self, title: "Warnung", message: "Wollen Sie die Stunde wirklich löschen?", numberOfTextFields: 0, actions: [("Ja",{
                self.deleteStunde()
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.navigationController?.popViewControllerAnimated(true)
            }), ("Nein", {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })])
        }
    }
    
    
    // MARK: - TextViewDelegate
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView!) {
        
        var max: Int = 0
        switch textView {
        case titelTextView, bemerkungTextView:
            max = 70
        case kuerzelTextView, raumTextView, dozentTextView, typTextView:
            max = 20
        default:
            max = 0
        }
        if textView.text.length >= max {
            textView.text = textView.text.subString(0, length: max)
        }
        if textView == bemerkungTextView {
            bemerkungsCounter.text = "\(textView.text.length)/70"
        }
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        saveStunde(textView)
    }
    
    // MARK: - DB Arbeit
    func saveStunde(sender: UITextView) {
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde!.ident, stunde!.student.matrnr, stunde!.anfang)
        let array = context.executeFetchRequest(request, error: nil)
        var tempStunde = array?.first as Stunde
        switch sender {
        case titelTextView:
            tempStunde.titel = sender.text
        case kuerzelTextView:
            tempStunde.kurzel = sender.text
        case raumTextView:
            tempStunde.raum = sender.text
        case dozentTextView:
            tempStunde.dozent = sender.text
        case bemerkungTextView:
            tempStunde.bemerkungen = sender.text
        case typTextView:
            tempStunde.typ = sender.text
        default:
            break
        }
        context.save(nil)
        stunde = tempStunde
        delegate?.SPPortraitDetailPhoneChangedStundeAtIndex(index)
    }
    
    func deleteStunde() {
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde!.ident, stunde!.student.matrnr, stunde!.anfang)
        let array = context.executeFetchRequest(request, error: nil)
        var tempStunde = array?.first as Stunde
        context.deleteObject(tempStunde)
        context.save(nil)
        delegate?.SPPortraitDetailPhoneDeletedStundeAtIndex(index)
    }
    
    // MARK: - Hilfsfunktionen
    func formattedDate(date: NSDate!) -> String {
        let wochentag = date.weekdayString()
        let uhrzeit = date.stringFromDate("HH:mm")
        return "\(wochentag) - \(uhrzeit) Uhr"
    }
}