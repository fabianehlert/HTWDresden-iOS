//
//  GradeCell.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCell: UITableViewCell {

	private var label: UILabel?
	
	var grade: Grade? {
		didSet{
			setupFromGrade(grade)
		}
	}
	
	func setupFromGrade(grade: Grade?) {
		guard let grade = grade else { return }
		label?.text = "\(grade.credits)"
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		label = UILabel(frame: bounds)
		addSubview(label!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
