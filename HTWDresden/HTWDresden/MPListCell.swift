//
//  MPListCell.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 25.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPListCell: UITableViewCell {
    
    var mensaName: String! {
        didSet{
            titleLabel.text = mensaName
        }
    }
    
    var mensaBild: UIImage? {
        didSet{
            mensaPicture.image = mensaBild
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mensaPicture: UIImageView!

}
