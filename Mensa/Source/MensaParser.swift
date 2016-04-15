//
//  MensaParser.swift
//  Pods
//
//  Created by Daniel Martin on 21.03.16.
//
//

import Foundation

struct MensaData {
	var strTitle: String
	var strDescription: String
	var strMensa: String
	var strCost: String
}

class Parser: NSObject, NSXMLParserDelegate {
	var parser = NSXMLParser()
	var strPath = ""
	var strTitle = ""
	var strDescription = ""
	var strMensa = ""
	var strCost = ""
	var bParseTitle = false
	var bParseDescription = false
	var bParseMensa = false
	var mensaData = [String: [MensaData]]()

	override init() {
		super.init()
	}

	init(strPath: String) {
		self.strPath = strPath
	}

	func loadData() -> [String: [MensaData]] {
		let url: NSURL = NSURL(string: strPath)!
		parser = NSXMLParser(contentsOfURL: url)!
		parser.delegate = self
		let success: Bool = parser.parse()

		if success {
			print("Parsing war erfolgreich!")
		}
		else {
			print("Fehler beim Parsen der Mensadaten!")
		}
		return mensaData
	}

	func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
		if elementName == "title" {
			bParseTitle = true
		}
		else if elementName == "description" {
			bParseDescription = true
		}
		else if elementName == "author" {
			bParseMensa = true
		}
	}

	func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "title" {
			bParseTitle = false
		}
		else if elementName == "description" {
			bParseDescription = false
		}
		else if elementName == "author" {
			bParseMensa = false
			let startRange = self.strTitle.rangeOfString("(")
			let endRange = self.strTitle.rangeOfString("EUR)")
			if startRange != nil && endRange != nil {
				var intIndex: Int = self.strTitle.startIndex.distanceTo(startRange!.startIndex)
				let startIndex = self.strTitle.startIndex.advancedBy(intIndex + (startRange?.count)!)
				intIndex = self.strTitle.startIndex.distanceTo(endRange!.startIndex)
				let endIndex = self.strTitle.startIndex.advancedBy(intIndex + 2)
				let range = startIndex ... endIndex
				self.strCost = self.strTitle[range]
				self.strCost = self.strCost.stringByReplacingOccurrencesOfString("EUR", withString: "€")
			}

			if mensaData[strMensa] == nil {
				mensaData[strMensa] = [MensaData]()
			}

			mensaData[strMensa]?.append(MensaData(strTitle: self.strTitle, strDescription: self.strDescription, strMensa: self.strMensa, strCost: self.strCost))
			self.strTitle.removeAll()
			self.strDescription.removeAll()
			self.strMensa.removeAll()
			self.strCost.removeAll()
			self.strCost.removeAll()
		}
	}

	func parser(parser: NSXMLParser, foundCharacters string: String) {
		if bParseTitle {
			self.strTitle.appendContentsOf(string)
		}
		else if bParseDescription {
			self.strDescription.appendContentsOf(string)
		}
		else if bParseMensa {
			self.strMensa.appendContentsOf(string)
		}
	}
}
