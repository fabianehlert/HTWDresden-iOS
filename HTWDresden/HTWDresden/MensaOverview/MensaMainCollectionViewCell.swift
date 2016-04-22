import UIKit

class MensaMainCollectionViewCell: UICollectionViewCell {
	var mensa: String? {
		didSet {
			label.text = mensa
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	var label: UILabel!

	private func setup() {
		contentView.backgroundColor = .whiteColor()

		label = UILabel(frame: bounds)
		label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		label.text = "Mensa"
		contentView.addSubview(label)
	}

	override var highlighted: Bool {
		didSet {
			contentView.backgroundColor = highlighted ? .grayColor() : .whiteColor()
		}
	}
    override var selected: Bool {
        didSet {
            contentView.backgroundColor = selected ? .grayColor() : .whiteColor()
        }
    }
}
