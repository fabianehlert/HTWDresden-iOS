//
//  MPMainCell.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 27.08.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MPMainCell: UITableViewCell, NSXMLParserDelegate {

    var speise: Speise! {
        didSet{
            MPTitleLabel.text = speise.title
            MPDescLabel.text = speise.desc
            if speise.bild != nil { MPImageView.image = UIImage(data: speise.bild) }
            else { MPImageView.image = nil }
        }
    }
    
    @IBOutlet weak var MPImageView: UIImageView!
    @IBOutlet weak var MPTitleLabel: UILabel!
    @IBOutlet weak var MPDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getImage() {
        if self.MPImageView.image != nil {
            return
        }
        self.MPImageView.image = nil
        dispatch_async(DIFF_QUEUE) {
            setNetworkIndicator(true)
            var request = NSURLRequest(URL: NSURL(string: self.speise.link))
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                response, data, error in
                if data == nil {
                    self.MPImageView.image = nil
                }
                dispatch_async(DIFF_QUEUE) {
                    setNetworkIndicator(false)
                    let html: String = NSString(data: data, encoding: NSUTF8StringEncoding)
                    let start = html.indexOf("<div id=\"spalterechtsnebenmenue\">")
                    var dataAfterHtml = html.subString(start, length: html.lengthAfterIndex(start))
                    dataAfterHtml = dataAfterHtml.subString(0, length: dataAfterHtml.indexOf("<div id=\"speiseplaninfos\">"))
                    dataAfterHtml.replace("&", withString: " und")
                    dataAfterHtml += "</div>"
                    
                    let parser = NSXMLParser(data: dataAfterHtml.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
                    parser.delegate = self
                    parser.parse()
                }
            })
        }
    }
    
    // MARK: - XMLParserDelegate
    var inEssenBild = false
    func parser(parser: NSXMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        let attributes = attributeDict as? [String: String]
        if elementName == "div" && attributes != nil && attributes?["id"] != nil && attributes?["id"]! == "essenbild" {
            inEssenBild = true
        }
        if elementName == "a" && inEssenBild {
            loadImageFromURL(attributes!["href"])
            parser.abortParsing()
        }
    }
    
    func loadImageFromURL(string: String?) {
        if string == nil {
            println("Kein Bild gefunden..")
            return
        }
        let image = UIImage(data: NSData(contentsOfURL: NSURL(string: string!)))
        dump(image)
        if speise != nil { speise.bild = UIImagePNGRepresentation(image) }
        dispatch_async(MAIN_QUEUE) {
            self.MPImageView.image = image
            (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext?.save(nil)
        }
    }

}


























