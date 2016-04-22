//
//  GradesSettingsController.swift
//  Pods
//
//  Created by Benjamin Herzog on 22/02/16.
//
//

import UIKit

class TextField: UITextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup() {
		backgroundColor = .whiteColor()

		borderStyle = .RoundedRect
	}
}

protocol GradesSettingsControllerDelegate {
	func didUpdateValues()
}

class GradesSettingsController: UIViewController {
	var delegate: GradesSettingsControllerDelegate?

	private let username: TextField = {
		let u = TextField()
		u.autocapitalizationType = .None
		u.placeholder = "S-Nummer"
		return u
	}()
	private let password: TextField = {
		let p = TextField()
		p.secureTextEntry = true
		p.placeholder = "Passwort"
		return p
	}()

	private var bConfirm: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

	private var isEdited = false

	var settings: Settings? {
		didSet {
			username.text = settings?.sNumber
			password.text = settings?.password
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schließen", style: .Plain, target: self, action: #selector(GradesSettingsController.dismiss))

		view.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)

		username.delegate = self
		password.delegate = self

		username.frame = CGRect(x: 0, y: 68, width: view.bounds.size.width, height: 30)
		username.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]

		password.frame = CGRect(x: 0, y: username.frame.origin.y + username.frame.size.height + 8, width: username.frame.size.width, height: 30)
		password.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]

		bConfirm.setTitle("Bestätigen", forState: .Normal)
		bConfirm.addTarget(self, action: #selector(GradesSettingsController.dismiss), forControlEvents: .TouchUpInside)
		bConfirm.backgroundColor = UIColor(red: 0, green: 92 / 255, blue: 153 / 255, alpha: 1)
		bConfirm.frame = CGRect(x: 0, y: password.frame.origin.y + password.frame.size.height + 8, width: username.frame.size.width, height: 40)

		view.addSubview(username)
		view.addSubview(password)
		view.addSubview(bConfirm)
	}

	func dismiss() {
		dismissViewControllerAnimated(true, completion: nil)
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		username.becomeFirstResponder()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		settings?.sNumber = username.text
		settings?.password = password.text

		if isEdited {
			// sag bescheid
			delegate?.didUpdateValues()
		}
	}
}

extension GradesSettingsController: UITextFieldDelegate {
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		isEdited = true
		return true
	}
}
