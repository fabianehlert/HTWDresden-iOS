//
//  MPMainCell.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPMainCell: UITableViewCell {

    var speise: Speise! {
        didSet{
            MPTitleLabel.text = speise.title
            MPDescLabel.text = speise.desc
        }
    }
    
    @IBOutlet weak var MPImageView: UIImageView!
    @IBOutlet weak var MPTitleLabel: UILabel!
    @IBOutlet weak var MPDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
