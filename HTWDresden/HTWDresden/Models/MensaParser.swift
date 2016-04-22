import Foundation

struct MensaData {
	var strTitle: String
	var strDescription: String
	var strMensa: String
	var strCost: String
}

class Parser: NSObject, NSXMLParserDelegate {
	var strPath = ""
	var strTitle = ""
	var strDescription = ""
	var strMensa = ""
	var strCost = ""
    var bParseItem = false
	var bParseTitle = false
	var bParseDescription = false
	var bParseMensa = false
	var mensaData = [String: [MensaData]]()

	init(strPath: String) {
		self.strPath = strPath
		super.init()
	}

	func loadData(completion: [String: [MensaData]] -> Void) {
		guard let url = NSURL(string: self.strPath) else {
			return
		}

		NSURLSession.sharedSession().dataTaskWithURL(url) {
			data, response, error in

			var result: [String: [MensaData]] = [:]

			defer {
				NSOperationQueue.mainQueue().addOperationWithBlock {
					completion(result)
				}
			}

			if let error = error {
				print(error)
				return
			}

			guard let response = response as? NSHTTPURLResponse else {
				return
			}

			let statusCode = response.statusCode
			print("status code: ", statusCode)

			guard let data = data where statusCode == 200 else {
				return
			}

			let parser = NSXMLParser(data: data)
			parser.delegate = self
			let success = parser.parse()

			if success {
				print("Parsing war erfolgreich!")
				result = self.mensaData
			}
			else {
				print("Fehler beim Parsen der Mensadaten!")
			}
		}.resume()
	}

	func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        if elementName == "item" {
            bParseItem = true
        }
        if !bParseItem {
            return
        }
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
        if elementName == "item" {
            bParseItem = false
        }
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
