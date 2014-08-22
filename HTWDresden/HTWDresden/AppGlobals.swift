//
//  AppGlobals.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 21.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit
import Foundation

let SUITNAME_NSUSERDEFAULTS = "group.HTW.TodayExtensionSharingDefaults"
let userDefaults = NSUserDefaults(suiteName: SUITNAME_NSUSERDEFAULTS)

let DIFF_QUEUE = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
let MAIN_QUEUE = dispatch_get_main_queue()

func setNetworkIndicator(on: Bool) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = on
}

func device() -> UIUserInterfaceIdiom {
    return UIDevice.currentDevice().userInterfaceIdiom
}


// MARK: - Alert that works on iOS 7 and 8
class HTWAlert: NSObject, UIAlertViewDelegate {
    
    var actions: [(title: String,action: (() -> Void)?)]!
    var numberOfTextFields: Int!
    var alert8: UIAlertController!
    var alert7: UIAlertView!
    
    override init() {}
    
    func alertInViewController(sender: AnyObject, title: String, message: String, numberOfTextFields: Int, actions: [(title: String,action: (() -> Void)?)]) {
        self.actions = actions
        self.numberOfTextFields = numberOfTextFields
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            // iOS 8
            alert8 = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            for var i = 0; i < numberOfTextFields; i++ {
                alert8.addTextFieldWithConfigurationHandler(nil)
            }
            for (index,(title, function)) in enumerate(actions) {
                alert8.addAction(UIAlertAction(title: title, style: .Default, handler: {
                    action in
                    let temp  = self.actions[index].action
                    temp?()
                }))
            }
            sender.presentViewController(alert8, animated: true, completion: nil)
        }
        else {
            // iOS 7
            alert7 = UIAlertView()
            alert7.title = title
            alert7.message = message
            alert7.delegate = self
            for (title, function) in self.actions {
                alert7.addButtonWithTitle(title)
            }
            switch numberOfTextFields {
            case 1:
                alert7.alertViewStyle = .PlainTextInput
            case 2:
                alert7.alertViewStyle = .LoginAndPasswordInput
            default:
                break
            }
            alert7.show()
            
        }
    }
    
    func stringFromTextFieldAt(index: Int) -> String? {
        if index >= numberOfTextFields {
            println("Tried to reach textField out of index.. aborting")
            return nil
        }
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            return (alert8.textFields[index] as UITextField).text
        }
        else {
            return alert7.textFieldAtIndex(index).text
        }
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        self.actions[buttonIndex].action?()
    }
    
}

