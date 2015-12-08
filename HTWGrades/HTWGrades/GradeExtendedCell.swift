//
//  GradeExtendedCell.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 08/12/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

class GradeExtendedCell: GradeCell {

    @IBOutlet private weak var numberLabel: UILabel?
    @IBOutlet weak var subjectLabel: UILabel?
    @IBOutlet weak var stateLabel: UILabel?
    @IBOutlet weak var creditsLabel: UILabel?
    @IBOutlet weak var gradeLabel: UILabel?
    @IBOutlet weak var semesterLabel: UILabel?
    
    override func setupFromGrade(grade: Grade?) {
        guard let grade = grade else {
            for view in contentView.subviews {
                if let label = view as? UILabel {
                    label.text = nil
                }
            }
            return
        }
        
        numberLabel?.text = grade.nr.description
        subjectLabel?.text = grade.subject
        stateLabel?.text = grade.state
        creditsLabel?.text = grade.credits.description
        gradeLabel?.text = grade.grade.description
        semesterLabel?.text = grade.semester
    }
}
