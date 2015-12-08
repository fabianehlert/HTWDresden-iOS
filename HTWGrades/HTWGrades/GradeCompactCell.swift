//
//  GradeCompactCell.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCompactCell: GradeCell {

    @IBOutlet private weak var subjectLabel: UILabel?
    @IBOutlet private weak var gradeLabel: UILabel?
	
	override func setupFromGrade(grade: Grade?) {
		guard let grade = grade else { return }
        
        subjectLabel?.text = grade.subject
        gradeLabel?.text = grade.grade.description
	}
    
}
