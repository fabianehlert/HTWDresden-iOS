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


func setNetworkIndicator(on: Bool) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = on
}

