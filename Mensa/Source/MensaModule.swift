//
//  MensaModule.swift
//  Pods
//
//  Created by Benjamin Herzog on 04/03/16.
//
//

import Foundation
import Core

public class MensaModule: Core.Module {
	
	public init() { }
	
	public static var shared = MensaModule()
	
	public var router: Router?
	
	public var name: String { return "Mensa" }
	public var image: UIImage { return UIImage() }
	
	public var initialController: UIViewController { return MensaMainViewController(router: router).wrapInNavigationController() }
}
