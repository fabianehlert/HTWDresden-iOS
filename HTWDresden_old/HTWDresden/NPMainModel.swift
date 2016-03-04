//
//  NPMainModel.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 05.01.15.
//  Copyright (c) 2015 Benjamin Herzog. All rights reserved.
//

import UIKit
import Alamofire

class NPMainModel {
    
    
    private let COURSES_URL = NSURL(string: "https://wwwqis.htw-dresden.de/appservice/getcourses")!
    private let GRADES_URL = NSURL(string: "https://wwwqis.htw-dresden.de/appservice/getgrades")!
    
    private var completion: (()->())!
    
    init() {
        
    }
    
    func starte(completionHander: ()->()) {
        completion = completionHander
        ladeNotenAusDB()
        if noten?.count == 0 {
            downloadeNoten()
        }
    }
    
    func refreshNoten(completionHander: ()->()) {
        completion = completionHander
        downloadeNoten()
    }
    
    private var noten: [[Note]]?
    
    var anzahlNoten: Int {
        get{
            var erg = 0
            for semester in noten! {
                erg += semester.count
            }
            return erg
        }
    }

    private var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    
    func numberOfSections() -> Int {
        return noten?.count ?? 0
    }
    
    func numberOfRowsIn(section section: Int) -> Int {
        return noten?[section].count ?? 0
    }
    
    func semesterNameFor(section section: Int) -> String {
        return noten?[section].first!.semester ?? ""
    }
    
    func noteAt(indexPath indexPath: NSIndexPath) -> Note? {
        return noten?[indexPath.section][indexPath.row]
    }
    
    private func ladeNotenAusDB() {
        let request = NSFetchRequest(entityName: "Note")
        request.predicate = NSPredicate(format: "user = %@", user)
        let array = context.executeFetchRequest(request, error: nil) as [Note]
        noten = groupBySemester(daten: array)
        completion()
    }
    
    private func löscheAlleNotenVonUser() {
        let request = NSFetchRequest(entityName: "Note")
        request.predicate = NSPredicate(format: "user = %@", user)
        let array = context.executeFetchRequest(request, error: nil) as [Note]
        for note in array {
            context.deleteObject(note)
        }
        context.save(nil)
    }
    
    internal func downloadeNoten() {
        löscheAlleNotenVonUser()
        println("== Downloade neue Noten für Nutzer mit Kennung: \(user.matrnr)")
        
        var postString = "sNummer=\(SNUMMER)&RZLogin=\(RZLOGIN)"
        var postData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var request = NSMutableURLRequest(URL: COURSES_URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.timeoutInterval = 10
        
        /*Alamofire.request(request)
            .responseJSON { _, response, json, error in
                
                
                if let studienGänge = json as? [[String:String]] {
                    
                    for studiengang in studienGänge {
                        
                        let AbschlNr = studiengang["AbschlNr"]!
                        let StgNr = studiengang["StgNr"]!
                        let POVersion = studiengang["POVersion"]!
                        
                        
                        var postString2 = "sNummer=s68311&RZLogin=HD5rdf92&AbschlNr=\(AbschlNr)&StgNr=\(StgNr)&POVersion=\(POVersion)"
                        var postData2 = postString2.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                        var request2 = NSMutableURLRequest(URL: self.GRADES_URL)
                        request2.HTTPMethod = "POST"
                        request2.HTTPBody = postData2
                        request2.timeoutInterval = 10
                        
                        Alamofire.request(request2)
                        .responseJSON({ (_, _, json2, _) -> Void in
                            
                            if let fächer = json2 as? [[String:String]] {
                                
                                var fächerSortiert = fächer.sorted { $0["PrNote"]! < $1["PrNote"]! }
                                
                                for fach in fächerSortiert {
                                    
                                    //println((fach["PrTxt"] ?? "") + " " + (fach["PrNote"] ?? ""))
                                    
                                }
                                
                            }
                            
                        })
                    }
                    
                }
                
                
            }*/
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            response, data, error in
            
            if error != nil {
                HTWerror(error.localizedDescription)
                return
            }
            
            let statusCode = (response as! NSHTTPURLResponse).statusCode
            
            switch statusCode {
            case 401, 402:
                HTWwarning("Login fehlgeschlagen.")
                return
            default:
                break
            }
            
            let studienGänge = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [[String:String]]
            
            for studiengang in studienGänge {
                let AbschlNr = studiengang["AbschlNr"]!
                let StgNr = studiengang["StgNr"]!
                let POVersion = studiengang["POVersion"]!
                
                var postString = "sNummer=\(SNUMMER)&RZLogin=\(RZLOGIN)&AbschlNr=\(AbschlNr)&StgNr=\(StgNr)&POVersion=\(POVersion)"
                var postData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                var request = NSMutableURLRequest(URL: self.GRADES_URL)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.timeoutInterval = 10
                
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    response, data, error in
                    
                    if error != nil {
                        HTWerror(error.localizedDescription)
                        return
                    }
                    
                    switch statusCode {
                    case 401, 402:
                        HTWwarning("Login fehlgeschlagen.")
                        return
                    default:
                        break
                    }
                    
                    let noten = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as [[String: NSString]]
                    for temp in noten {
                        var neueNote = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: self.context) as Note
                        neueNote.credits = NSNumber(double: temp["EctsCredits"]!.doubleValue)
                        neueNote.name = temp["PrTxt"]!
                        neueNote.note = NSNumber(double: temp["PrNote"]!.doubleValue/100)
                        neueNote.nr = NSNumber(double: temp["PrNr"]!.doubleValue)
                        neueNote.semester = self.ausformuliertesSemesterVon(temp["Semester"]!)
                        neueNote.status = temp["Status"]!
                        neueNote.versuch = temp["Versuch"]!.doubleValue
                        neueNote.datum = temp["PrDatum"]! != "" ? NSDate.dateFromString(temp["PrDatum"]!, format: "dd.MM.yyyy") : nil
                        neueNote.form = temp["PrForm"]!
                        neueNote.vermerk = temp["Vermerk"]!
                        neueNote.voDatum = temp["VoDatum"]! != "" ? NSDate.dateFromString(temp["VoDatum"]!, format: "dd.MM.yyyy") : nil
                        user.addNotenObject(neueNote)
                    }
                    self.context.save(nil)
                    self.ladeNotenAusDB()
                    if self.noten?.count == 0 {
                        HTWwarning("Keine Noten gefunden..")
                    }
                }
            }
        }
    }
    
    private func ausformuliertesSemesterVon(semester: String) -> String {
        let jahr = semester[0...4]
        let typ = "\(semester[4])"
        
        switch typ.toInt()! {
        case 1:
            return "Sommersemester \(jahr)"
        case 2:
            return "Wintersemester \(jahr)/\(jahr.toInt()! + 1)"
        default:
            break
        }
        
        return ""
    }
    
    private func groupBySemester(#daten: [Note]) -> [[Note]] {
        var erg = [[Note]]()
        var bekannteSemester = [String:Int]()
        
        for temp in daten {
            var tempCopy = temp
//            tempCopy.semester = ausformuliertesSemesterVon(tempCopy.semester)
            var semester = tempCopy.semester
            if bekannteSemester[semester] == nil {
                bekannteSemester[semester] = erg.count
                erg.append([Note]())
            }
            erg[bekannteSemester[semester]!].append(tempCopy)
        }
        
        erg.sort {
            semester1, semester2 in
            return semester1[0].semester.componentsSeparatedByString(" ")[1] > semester2[0].semester.componentsSeparatedByString(" ")[1]
        }
        erg = erg.map {
            a in
            return sorted(a) {
                $0.name < $1.name
            }
        }
        
        return erg
    }


}
