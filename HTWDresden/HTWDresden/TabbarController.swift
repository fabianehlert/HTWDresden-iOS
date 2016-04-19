//
//  TabbarController.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 19/04/16.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import UIKit
import Cartography
import ReactiveUI

class TabbarController: UIViewController {
	let tabbar: UIStackView = {
		let v = UIStackView()
		v.axis = .Horizontal
		v.distribution = .FillEqually
		return v
	}()
	let container = UIView()

	var names: [String]
	var modules: [String: UIViewController]

	init(items: [(name: String, module: Module)]) {
		modules = Dictionary(items.map { ($0.0, $0.1.initialController) })
		names = items.map { $0.name }
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .whiteColor()

		view.addSubview(tabbar)
		view.addSubview(container)

		constrain(tabbar, container) {
			$0.width == $0.superview!.width
			$0.height == 44
			$0.bottom == $0.superview!.bottom
			$0.leading == $0.superview!.leading

			$1.bottom == $0.top
			$1.width == $0.width
			$1.top == $1.superview!.top
			$1.leading == $0.leading
		}

		let views: [UIView] = names.map {
			name in
			let view = UIButton(type: .System)
			view.setTitle(name, forState: .Normal)
            view.backgroundColor = .redColor()
			view.addAction({ _ in

				self.switchToModule(name)
				}, forControlEvents: .TouchUpInside)
			return view
		}

		views.forEach {
			self.tabbar.addArrangedSubview($0)
		}
	}

	var currentModule: String?
	var currentViewController: UIViewController?

	func switchToModule(module: String) {
		guard module != currentModule else {
			return
		}

		currentModule = module

		guard let toController = modules[module] else
		{
			return
		}

		if let fromController = currentViewController {
			fromController.view.removeFromSuperview()
		}

		currentViewController = toController

		guard let currentController = currentViewController else
		{
			print("Tabbar current controller was not set correctly.")
			return
		}

		currentController.view.frame = container.bounds
		currentController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		container.addSubview(currentController.view)
		currentController.willMoveToParentViewController(self)
		addChildViewController(currentController)
		currentController.didMoveToParentViewController(self)
	}
}
