//
//  SPPortraitDetailPhoneTVC.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 23.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class SPPortraitDetailPhoneTVC: UITableViewController, UITextViewDelegate {
    
    private let TEXT_FONT = UIFont.HTWBaseFont()
    private let TEXT_COLOR = UIColor.HTWTextColor()
    private let VIEW_BACKGROUND = UIColor.HTWSandColor()
    private let CELL_BACKGROUND = UIColor.HTWWhiteColor()
    
    private let TAG_LABEL = 1
    private let TAG_TEXTVIEW = 2
    
    var stunde: Stunde?
    
    var bemerkungsCounter: UILabel!
    
    var myAlert = HTWAlert()

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
            var textField = cell.contentView.viewWithTag(TAG_TEXTVIEW) as UITextView
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
                textField.text = stunde?.kurzel.componentsSeparatedByString(" ").last
            case 5:
                titleLabel.text = "Semester"
                textField.text = stunde?.semester
            case 6:
                titleLabel.text = "Anfang"
                textField.text = formattedDate(stunde?.anfang)
            case 7:
                titleLabel.text = "Ende"
                textField.text = formattedDate(stunde?.ende)
            default:
                titleLabel.text = ""
                textField.text = ""
            }
            titleLabel.textColor = TEXT_COLOR
            titleLabel.font = TEXT_FONT
            textField.textColor = TEXT_COLOR
            textField.font = TEXT_FONT
            
        }
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
            var titleLabel = cell.contentView.viewWithTag(TAG_LABEL) as UILabel
            var textField = cell.contentView.viewWithTag(TAG_TEXTVIEW) as UITextView
            titleLabel.text = "Bemerkung"
            textField.text = stunde?.bemerkungen
            bemerkungsCounter = UILabel(frame: CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 20, width: 40, height: 15))
            bemerkungsCounter.textColor = UIColor.HTWGrayColor()
            bemerkungsCounter.font = UIFont.HTWVerySmallFont()
            bemerkungsCounter.text = stunde?.bemerkungen != nil ? "\(stunde?.bemerkungen.length)/70" : "0/70"
            cell.contentView.addSubview(bemerkungsCounter)
            
            titleLabel.textColor = TEXT_COLOR
            titleLabel.font = TEXT_FONT
            textField.textColor = TEXT_COLOR
            textField.font = TEXT_FONT
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
        if indexPath.section == 2 {
            myAlert.alertInViewController(self, title: "Warnung", message: "Wollen Sie die Stunde wirklich löschen?", numberOfTextFields: 0, actions: [("Ja",{
                println("LÖSCHEN NICHT IMPLEMENTIERT")
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }), ("Nein", {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })])
        }
    }
    
    
    // MARK: - TextViewDelegate
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            println("SPEICHERN NICHT IMPLEMENTIERT")
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView!) {
        if textView.text.length >= 70 {
            textView.text = textView.text.subString(0, length: 70)
        }
        bemerkungsCounter.text = "\(textView.text.length)/70"
    }
    
    // MARK: -Hilfsfunktionen
    func formattedDate(date: NSDate!) -> String {
        let wochentag = date.weekdayString()
        let uhrzeit = date.stringFromDate("HH:mm")
        return "\(wochentag) - \(uhrzeit) Uhr"
    }

}
