//
//  NPMainTVCell.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 05.01.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import UIKit

class NPStandardMainTVCell: UITableViewCell {
    
    var note: Note! {
        didSet{
            fachLabel.text = note.name
            noteLabel.text = NSString(format: "%.1f", note.note.floatValue)
        }
    }
    
    @IBOutlet private weak var fachLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    
}


class NPDetailMainTVCell: UITableViewCell {
    
    var note: Note! {
        didSet{
            fachLabel.text = note.name
            noteLabel.text = NSString(format: "%.1f", note.note.floatValue)
            versuchLabel.text = "\(note.versuch)"
            nrLabel.text = "\(note.nr)"
            statusLabel.text = note.status
            creditsLabel.text = NSString(format: "%.1f", note.credits.floatValue)
            datumLabel.text = note.datum != nil ? note.datum.stringFromDate("dd.MM.yyyy") : ""
            voDatumLabel.text = note.voDatum != nil ? note.voDatum.stringFromDate("dd.MM.yyyy") : ""
        }
    }
    
    @IBOutlet private weak var fachLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    @IBOutlet private weak var versuchLabel: UILabel!
    @IBOutlet private weak var nrLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var creditsLabel: UILabel!
    @IBOutlet private weak var datumLabel: UILabel!
    @IBOutlet private weak var voDatumLabel: UILabel!
    
}
