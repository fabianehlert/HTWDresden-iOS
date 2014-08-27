//
//  SPPortraitDetailPad.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 22.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

protocol SPPortraitDetailPadDelegate {
    
    func SPDetailPadChangedStundeAtIndex(index: Int)
    
}



class SPPortraitDetailPad: UIView, UITextViewDelegate {
    
    private let textColor = UIColor.HTWSandColor()
    private let font = UIFont.HTWBaseFont()
    private let background = UIColor.HTWDarkGrayColor()
    
    var delegate: SPPortraitDetailPadDelegate?

    var index: Int?
    var stunde: Stunde? {
        didSet{
            titelLabel.text = stunde?.titel
            kuerzelLabel.text = stunde?.kurzel
            raumLabel.text = stunde?.raum
            dozentLabel.text = stunde?.dozent
            typLabel.text = stunde?.typ
            semesterLabel.text = stunde?.semester
            anfangLabel.text = formattedDate(stunde?.anfang)
            endeLabel.text = formattedDate(stunde?.ende)
            bemerkungenTextView.text = stunde?.bemerkungen
            bemerkungsCounter.text = stunde?.bemerkungen != nil ? "\(stunde!.bemerkungen.length)/70" : "0/70"
        }
    }
    
    @IBOutlet var titelLabel: UITextView!
    @IBOutlet var kuerzelLabel: UITextView!
    @IBOutlet var raumLabel: UITextView!
    @IBOutlet var dozentLabel: UITextView!
    @IBOutlet var typLabel: UITextView!
    @IBOutlet var semesterLabel: UITextView!
    @IBOutlet var anfangLabel: UITextView!
    @IBOutlet var endeLabel: UITextView!
    @IBOutlet var bemerkungenTextView: UITextView!
    @IBOutlet var bemerkungsCounter: UILabel!
    
    @IBOutlet var container: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func awakeFromNib() {
        bemerkungenTextView.delegate = self
        backgroundColor = background
        
    }
    
    private func commonInit() {
        //Load the contents of the nib
        let nibName = "SPPortraitDetailPad"
        let nib = UINib(nibName: nibName, bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        addSubview(container)
        container.backgroundColor = background
        
        bemerkungenTextView.backgroundColor = background
        bemerkungenTextView.font = font
        bemerkungenTextView.textColor = textColor
        
        bemerkungsCounter.textColor = UIColor.HTWGrayColor()
        bemerkungsCounter.font = UIFont.HTWVerySmallFont()
        bemerkungsCounter.text = stunde?.bemerkungen != nil ? "\(stunde!.bemerkungen.length)/70" : "0/70"
    }
    
    // MARK: - TextView Delegate
    func textViewDidBeginEditing(textView: UITextView!) {
        UIView.animateWithDuration(0.2) {
            self.frame.origin.y -= 250
        }
    }
    
    func textViewDidChange(textView: UITextView!) {
        if textView.text.length >= 70 {
            textView.text = textView.text.subString(0, length: 70)
        }
        bemerkungsCounter.text = "\(textView.text.length)/70"
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        saveChangesInDB()
        UIView.animateWithDuration(0.2) {
            self.frame.origin.y += 250
        }
    }
    
    // MARK: - Hilfsfunktionen
    func formattedDate(date: NSDate!) -> String {
        if date == nil { return "" }
        let wochentag = date.weekdayString()
        let uhrzeit = date.stringFromDate("HH:mm")
        return "\(wochentag) - \(uhrzeit) Uhr"
    }
    
    func saveChangesInDB() {
        if stunde == nil {
            return
        }
        let request = NSFetchRequest(entityName: "Stunde")
        request.predicate = NSPredicate(format: "ident = %@ && student.matrnr = %@ && anfang = %@", stunde!.ident, stunde!.student.matrnr, stunde!.anfang)
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let tempArray = context.executeFetchRequest(request, error: nil)
        var newStunde = tempArray.first as Stunde
        newStunde.titel = titelLabel.text
        newStunde.kurzel = kuerzelLabel.text
        newStunde.typ = typLabel.text
        newStunde.raum = raumLabel.text
        newStunde.dozent = dozentLabel.text
        newStunde.bemerkungen = bemerkungenTextView.text
        self.stunde = newStunde
        context.save(nil)
        delegate?.SPDetailPadChangedStundeAtIndex(index!)
    }
}









