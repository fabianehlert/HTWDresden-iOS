//
//  SPPortraitDetailPad.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 22.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit


class SPPortraitDetailPad: NibView, UITextViewDelegate {
    
    private let textColor = UIColor.HTWSandColor()
    private let font = UIFont.HTWBaseFont()
    private let background = UIColor.HTWDarkGrayColor()

    var stunde: Stunde? {
        didSet{
            self.proxyView().titelLabel.text = stunde?.titel
            self.proxyView().kuerzelLabel.text = stunde?.kurzel.componentsSeparatedByString(" ").first
            self.proxyView().raumLabel.text = stunde?.raum
            self.proxyView().dozentLabel.text = stunde?.dozent
            self.proxyView().typLabel.text = stunde?.kurzel.componentsSeparatedByString(" ").last
            self.proxyView().semesterLabel.text = stunde?.semester
            self.proxyView().anfangLabel.text = formattedDate(stunde?.anfang)
            self.proxyView().endeLabel.text = formattedDate(stunde?.ende)
            self.proxyView().bemerkungenTextView.text = stunde?.bemerkungen
        }
    }
    
    @IBOutlet var titelLabel: UILabel!
    @IBOutlet var kuerzelLabel: UILabel!
    @IBOutlet var raumLabel: UILabel!
    @IBOutlet var dozentLabel: UILabel!
    @IBOutlet var typLabel: UILabel!
    @IBOutlet var semesterLabel: UILabel!
    @IBOutlet var anfangLabel: UILabel!
    @IBOutlet var endeLabel: UILabel!
    @IBOutlet var bemerkungenTextView: UITextView!
    
    override func nibName() -> String {
        return "SPPortraitDetailPad"
    }
    
    private func proxyView() -> SPPortraitDetailPad {
        return self.proxyView! as SPPortraitDetailPad
    }
    
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
        for view in subviews {
            if view is UILabel {
                (view as UILabel).textColor = textColor
                (view as UILabel).font = font
            }
            else if view is UITextView {
                (view as UITextView).backgroundColor = background
                (view as UITextView).font = font
                (view as UITextView).textColor = textColor
            }
        }
    }
    
    private func commonInit() {
        
    }
    
    // MARK: - TextView Delegate
    func textViewDidBeginEditing(textView: UITextView!) {
        UIView.animateWithDuration(0.2) {
            self.frame.origin.y -= 264
        }
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        println("Want to save bemerkungen... Not implemented yet.. :)")
        UIView.animateWithDuration(0.2) {
            self.frame.origin.y += 264
        }
    }
    
    // MARK: - Hilfsfunktionen
    func formattedDate(date: NSDate!) -> String {
        if date == nil { return "" }
        let wochentag = date.weekdayString()
        let uhrzeit = date.stringFromDate("HH:mm")
        return "\(wochentag) - \(uhrzeit) Uhr"
    }
}









