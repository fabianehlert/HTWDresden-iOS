//
//  MealDetailViewCell.swift
//  Pods
//
//  Created by Benjamin Herzog on 19/04/16.
//
//

import UIKit

class MealDetailViewCell: UITableViewCell {
    
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        imageView?.kf_setImageWithURL(NSURL(string: "https://cdn0.iconfinder.com/data/icons/small-n-flat/24/678134-sign-check-128.png")!)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
