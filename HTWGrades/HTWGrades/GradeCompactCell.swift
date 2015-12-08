//
//  GradeCompactCell.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCompactCell: UITableViewCell {

    @IBOutlet private weak var subjectLabel: UILabel?
    @IBOutlet private weak var gradeLabel: UILabel?
	
	var grade: Grade? {
		didSet{
			setupFromGrade(grade)
		}
	}
	
	func setupFromGrade(grade: Grade?) {
		guard let grade = grade else { return }
        
        subjectLabel?.text = grade.subject
        gradeLabel?.text = grade.grade.description
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupFromGrade(grade)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
