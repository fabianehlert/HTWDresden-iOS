//
//  GradesModule.swift
//  Pods
//
//  Created by Benjamin Herzog on 20/02/16.
//
//

import Foundation
import Core
import HTWGrades

class GradesModule: Core.Module {
    
    var router: Router?
    
    var name: String { return "Noten" }
    var image: UIImage { return UIImage() }
    
    var initialController: ViewController { return GradesListViewController(router: router) }
}
