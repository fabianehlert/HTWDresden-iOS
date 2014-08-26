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
    private let TEXT_COLOR = UIColor.HTWTextColor()
    private let VIEW_BACKGROUND = UIColor.HTWSandColor()
    private let CELL_BACKGROUND = UIColor.HTWWhiteColor()
    
    var delegate: SPPortraitDetailPhoneDelegate?
    
    private let TAG_LABEL = 1
    private let TAG_TEXTVIEW = 2
    
    var stunde: Stunde?
    var index: Int!
    
    var bemerkungsCounter: UILabel!
    
    lazy var myAlert = HTWAlert()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = VIEW_BACKGROUND
        view.backgroundColor = VIEW_BACKGROUND
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 8
        case 1, 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        switch indexPath.section {
        case 0,1:
            if indexPath.row == 0 {
                return 90
            }
            else {
                return 50
            }
        case 2:
            return 50
        default:
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
            var titleLabel = cell.contentView.viewWithTag(TAG_LABEL) as UILabel
            var textField = cell.contentView.viewWithTag(TAG_TEXTVIEW) as myTextView
            switch indexPath.row {
            case 0:
                titleLabel.text = "Titel"
                textField.text = stunde?.titel
            case 1:
                titleLabel.text = "Kürzel"
                textField.text = stunde?.kurzel
            case 2:
                titleLabel.text = "Raum"
                textField.text = stunde?.raum
            case 3:
                titleLabel.text = "Dozent"
                textField.text = stunde?.dozent
            case 4:
                titleLabel.text = "Typ"
                textField.text = stunde?.typ
            case 5:
                titleLabel.text = "Semester"
                textField.text = stunde?.semester
                textField.userInteractionEnabled = false
            case 6:
                titleLabel.text = "Anfang"
                textField.text = formattedDate(stunde?.anfang)
                textField.userInteractionEnabled = false
            case 7:
                titleLabel.text = "Ende"
                textField.text = formattedDate(stunde?.ende)
                textField.userInteractionEnabled = false
            default:
                titleLabel.text = ""
                textField.text = ""
                textField.userInteractionEnabled = false
            }
            titleLabel.textColor = TEXT_COLOR
            titleLabel.font = TEXT_FONT
            textField.textColor = TEXT_COLOR
            textField.font = TEXT_FONT
            textField.desc = titleLabel.text
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
            var titleLabel = cell.contentView.viewWithTag(TAG_LABEL) as UILabel
            var textField = cell.contentView.viewWithTag(TAG_TEXTVIEW) as myTextView
            titleLabel.text = "Bemerkung"
            textField.text = stunde?.bemerkungen
            if bemerkungsCounter != nil { bemerkungsCounter.removeFromSuperview() }
            bemerkungsCounter = nil
            bemerkungsCounter = UILabel(frame: CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, width: 40, height: 15))
            bemerkungsCounter.textColor = UIColor.HTWGrayColor()
            bemerkungsCounter.font = UIFont.HTWVerySmallFont()
            bemerkungsCounter.text = stunde?.bemerkungen != nil ? "\(stunde!.bemerkungen.length)/70" : "0/70"
            cell.contentView.addSubview(bemerkungsCounter)
            
            titleLabel.textColor = TEXT_COLOR
            titleLabel.font = TEXT_FONT
            textField.textColor = TEXT_COLOR
            textField.font = TEXT_FONT
            textField.desc = titleLabel.text
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("LoeschenCell") as UITableViewCell
            cell.textLabel.textColor = UIColor.HTWWhiteColor()
            cell.contentView.backgroundColor = UIColor.HTWRedColor()
            cell.textLabel.font = UIFont.HTWBaseBoldFont()
            cell.textLabel.backgroundColor = UIColor.HTWRedColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        getFirstResponder()?.resignFirstResponder()
        if indexPath.section == 2 {
            myAlert.alertInViewController(self, title: "Warnung", message: "Wollen Sie die Stunde wirklich löschen?", numberOfTextFields: 0, actions: [("Ja",{
                self.deleteStunde()
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.navigationController.popViewControllerAnimated(true)
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
        if textView.text.length >= 70 {
            textView.text = textView.text.subString(0, length: 70)
        }
        bemerkungsCounter.text = "\(textView.text.length)/70"
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        saveStunde((textView as myTextView).desc, aenderung: textView.text)
    }
    
    // MARK: - DB Arbeit
    func saveStunde(was: String?, aenderung: String!) {
        if was == nil { return }
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde!.ident, stunde!.student.matrnr, stunde!.anfang)
        let array = context.executeFetchRequest(request, error: nil)
        var tempStunde = array.first as Stunde
        switch was! {
        case "Titel":
            tempStunde.titel = aenderung
        case "Kürzel":
            tempStunde.kurzel = aenderung
        case "Raum":
            tempStunde.raum = aenderung
        case "Dozent":
            tempStunde.dozent = aenderung
        case "Bemerkung":
            tempStunde.bemerkungen = aenderung
        case "Typ":
            tempStunde.typ = aenderung
        default:
            break
        }
        context.save(nil)
        stunde = tempStunde
        tableView.reloadData()
        delegate?.SPPortraitDetailPhoneChangedStundeAtIndex(index)
    }
    
    func deleteStunde() {
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde!.ident, stunde!.student.matrnr, stunde!.anfang)
        let array = context.executeFetchRequest(request, error: nil)
        var tempStunde = array.first as Stunde
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

    func getFirstResponder() -> UIView? {
        
        for var i = 0; i < 2; i++ {
            let grenzeJ = i == 0 ? 4 : 1
            for var j = 0; j < grenzeJ; j++ {
                let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i))
                if currentCell == nil {
                    continue
                }
                for tempView in currentCell.contentView.subviews as [UIView] {
                    if tempView.isFirstResponder() {
                        return tempView
                    }
                }
            }

        }
        return nil
    }
}

class myTextView: UITextView {
    var desc: String?
}