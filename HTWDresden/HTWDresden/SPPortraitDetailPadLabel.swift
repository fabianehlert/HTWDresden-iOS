//
//  SPPortraitDetailPadLabel.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 26.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class SPPortraitDetailPadLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.HTWBaseFont()
        self.textColor = UIColor.HTWSandColor()
    }

}
