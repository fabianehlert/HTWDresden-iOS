//
//  GradesSettingsController.swift
//  Pods
//
//  Created by Benjamin Herzog on 22/02/16.
//
//

import Core

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
	}
}

protocol GradesSettingsControllerDelegate {
	func didUpdateValues()
}

class GradesSettingsController: ViewController {

	var delegate: GradesSettingsControllerDelegate?

	private let username: TextField = {
		let u = TextField()
		u.autocapitalizationType = .None
		return u
	}()
	private let password: TextField = {
		let p = TextField()
		p.secureTextEntry = true
		return p
	}()

	private var isEdited = false

	var settings: Settings? {
		didSet {
			username.text = settings?.sNumber
			password.text = settings?.password
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schließen", style: .Plain, target: self, action: "dismiss")

		view.backgroundColor = .blackColor()

		username.delegate = self
		password.delegate = self

		username.frame = CGRect(x: 0, y: 68, width: view.bounds.size.width, height: 30)
		username.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]

		password.frame = CGRect(x: 0, y: username.frame.origin.y + username.frame.size.height + 8, width: username.frame.size.width, height: 30)
		password.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]

		view.addSubview(username)
		view.addSubview(password)
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
