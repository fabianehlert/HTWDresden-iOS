//
//  ViewController.swift
//  BHTabbar
//
//  Created by Benjamin Herzog on 30.11.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class TabViewController {
    var name: String
    var picture: UIImage
    var viewController: UIViewController
    
    init(name: String, picture: UIImage, viewController: UIViewController) {
        self.name = name
        self.picture = picture
        self.viewController = viewController
    }
}

class BHTabbarController: UIViewController {

    
    private let SIZE = CGFloat(60)
    private let MIN_WIDTH = CGFloat(75)
    
    private var items = [TabViewController]()

    @IBOutlet private weak var tabbarSuperView: UIView!
    @IBOutlet private weak var tabbar: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var menuButton: UIButton!
    
    var visible: Bool = true {
        willSet{
            if visible {
                UIView.animateWithDuration(0.1) {
                    self.tabbarSuperView.frame.origin.y += CGFloat(self.SIZE - 10)
                    self.menuButton.frame.origin.y += CGFloat(self.SIZE - 10)
                    self.tabbar.userInteractionEnabled = false
                }
            }
            else {
                UIView.animateWithDuration(0.1) {
                    self.tabbarSuperView.frame.origin.y -= CGFloat(self.SIZE - 10)
                    self.menuButton.frame.origin.y -= CGFloat(self.SIZE - 10)
                    self.tabbar.userInteractionEnabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewController erstellen und items hinzufügen (über class TabViewController)
        var stundenPlanVC = UIStoryboard(name: "Stundenplan", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as! UINavigationController
        var mensaVC = UIStoryboard(name: "Mensa", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as! UINavigationController
        var notenVC = UIStoryboard(name: "Noten", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as! UINavigationController
        
        items.append(TabViewController(name: "Stundenplan", picture: UIImage(), viewController: stundenPlanVC))
        items.append(TabViewController(name: "Mensa", picture: UIImage(), viewController: mensaVC))
        items.append(TabViewController(name: "Noten", picture: UIImage(), viewController: notenVC))
        
        configureTabBar()
        
        activateItemAt(index: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureTabBar() {
        tabbar.contentSize = CGSize(width: CGFloat(items.count) * SIZE, height: SIZE)
        tabbar.showsHorizontalScrollIndicator = false
        tabbar.bounces = false
        
        var temp = MIN_WIDTH * CGFloat(items.count)
        var width = temp < CGFloat(view.frame.size.width) ? CGFloat(view.frame.size.width/CGFloat(items.count)) : MIN_WIDTH
        
        
        for (i, item) in items.enumerate() {
            let view = UIView(frame: CGRect(x: CGFloat(i) * width, y: CGFloat(0), width: width, height: SIZE))
            view.backgroundColor = UIColor.random()
            view.tag = i
            
            let label = UILabel(frame: CGRect(x: 0, y: SIZE*2/3, width: width, height: SIZE*1/3))
            label.text = item.name
            label.font = UIFont.systemFontOfSize(10)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.userInteractionEnabled = false
            view.addSubview(label)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SIZE*2/3, height: SIZE*2/3))
            imageView.center.x = view.center.x
            imageView.image = item.picture
            imageView.userInteractionEnabled = false
            view.addSubview(imageView)

            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: SIZE))
            button.tag = i
            button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            view.addSubview(button)
            
            tabbar.addSubview(view)
        }
    }
    
    var tempVC: UIViewController?
    func buttonPressed(sender: UIButton) {
        activateItemAt(index: sender.tag)
    }
    
    func activateItemAt(index index: Int) {
        let item = items[index]
        if item.viewController === tempVC { return }
        item.viewController.view.frame = self.contentView.bounds
        for view in self.contentView.subviews { (view as! UIView).removeFromSuperview() }
        self.contentView.addSubview(item.viewController.view)
        self.addChildViewController(item.viewController)
        item.viewController.didMoveToParentViewController(self)
        tempVC = item.viewController
    }

    @IBAction func menuButtonPressed(sender: AnyObject) {
        visible = !visible
    }
}

class StundenplanVC : UIViewController {
    override func viewDidLoad() {
        print("StundenplanVC --- viewDidLoad:")
    }
    override func viewWillAppear(animated: Bool) {
        print("StundenplanVC --- viewWillAppear:")
    }
    override func viewWillDisappear(animated: Bool) {
        print("StundenplanVC --- viewWillDisappear")
    }
}

class MensaVC : UIViewController {
    override func viewDidLoad() {
        print("MensaVC       --- viewDidLoad:")
    }
    override func viewWillAppear(animated: Bool) {
        print("MensaVC       --- viewWillAppear:")
    }
    override func viewWillDisappear(animated: Bool) {
        print("MensaVC       --- viewWillDisappear")
    }
}

extension UIColor {
    class func random() -> UIColor {
        let redValue = Float(rand() % 255) / 255
        let greenValue = Float(rand() % 255) / 255
        let blueValue = Float(rand() % 255) / 255
        
        return UIColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: 1)
    }
}