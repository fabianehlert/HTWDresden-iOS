//
//  PSCustomViewFromXib.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 22.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

public class NibView: UIView {
    public weak var proxyView: NibView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var view = self.loadNib()
        view.frame = self.bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.proxyView = view
        
        if let view = proxyView {
            self.addSubview(view)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeAfterUsingCoder(aDecoder: NSCoder!) -> AnyObject! {
        if self.subviews.count == 0 {
            var view = self.loadNib()
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
            let contraints = self.constraints()
            self.removeConstraints(contraints)
            view.addConstraints(contraints)
            view.proxyView = view
            return view
        }
        return self
    }
    
    private func loadNib() -> NibView {
        let bundle = NSBundle(forClass: self.dynamicType)
        return bundle.loadNibNamed(self.nibName(), owner: nil, options: nil)[0] as NibView
    }
    
    public func nibName() -> String {
        return ""
    }
}
