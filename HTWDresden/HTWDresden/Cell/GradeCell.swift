//
//  GradeCell.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 08/12/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import UIKit

class GradeCell: UITableViewCell {
    var grade: Grade? {
        didSet{
            setupFromGrade(grade)
        }
    }
    
    func setupFromGrade(grade: Grade?) {
        fatalError("Implement this method in your subclass!!!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupFromGrade(grade)
    }
}
