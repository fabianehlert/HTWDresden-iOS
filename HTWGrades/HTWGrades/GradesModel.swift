//
//  GradesModel.swift
//  HTWGrades
//
//  Created by Benjamin Herzog on 23/11/15.
//  Copyright © 2015 HTW Dresden. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

let getPos = "https://wwwqis.htw-dresden.de/appservice/getcourses"
let getGrade = "https://wwwqis.htw-dresden.de/appservice/getgrades"

class GradesModel {
	
	init() {
		
	}
	
	func start(completion: ([Grade] -> Void)? = nil) {
		
		loadCourses { success, data in
			
			if !success {
				print("course error")
				return
			}
			
			for course in data {
				
				self.loadGrades(course) {
					success, grades in
					
					if !success {
						print("grade error")
						return
					}
					
					completion?(grades)
					
				}
				
			}
			
		}
				
		
		
	}
	
	private func loadCourses(completion: (success: Bool, data: [Course]) -> Void) {
		
		Alamofire.request(.POST, getPos, parameters: ["sNummer": sNummer, "RZLogin": Passwort])
			.responseJSON {
				response in
				
				guard let coursesArray = response.result.value as? [[String: String]] else {
					completion(success: false, data: [])
					return
				}
				
				let courses = coursesArray.map {
					element in
					return Mapper<Course>().map(element)
					}.filter { $0 != nil }.map { $0! }
				
				completion(success: true, data: courses)
		}
		
	}
	
	private func loadGrades(course: Course, completion: (success: Bool, data: [Grade]) -> Void) {
		
		Alamofire.request(.POST, getGrade, parameters: ["sNummer": sNummer, "RZLogin": Passwort, "AbschlNr": course.AbschlNr, "POVersion": course.POVersion, "StgNr": course.StgNr])
			.responseJSON {
				jsonResponse in
				
				
				guard let allGrades = jsonResponse.result.value as? [[String: String]] else {
					completion(success: false, data: [])
					return
				}
				
				let grades = allGrades.map { Mapper<Grade>().map($0) }.filter { $0 != nil }.map { $0! }
				
				completion(success: true, data: grades)
		}
		
	}
	
}


struct Course: Mappable {
	var AbschlNr: String
	var POVersion: String
	var StgNr: String
	
	init?(_ map: Map) {
		AbschlNr = map["AbschlNr"].valueOrFail()
		POVersion = map["POVersion"].valueOrFail()
		StgNr = map["StgNr"].valueOrFail()
		
		if !map.isValid {
			return nil
		}
	}
	
	mutating func mapping(map: Map) {
		
	}
}

struct Grade: Mappable, CustomStringConvertible {
	
	var nr: Int = 0
	var subject: String
	var state: String
	var credits: Double = 0
	var grade: Double = 0
	var semester: String
	
	init?(_ map: Map) {
		
		
		subject = map["PrTxt"].valueOr("")
		state = map["Status"].valueOr("")
		semester = map["Semester"].valueOrFail()

		if !map.isValid {
			return nil
		}
	}
	
	mutating func mapping(map: Map) {
		let stringToIntTransform = TransformOf<Int, String>(fromJSON: { $0.map { Int($0) ?? 0 } }, toJSON: { "\($0 ?? 0)" })
		let stringToDoubleTransform = TransformOf<Double, String>(fromJSON: { $0.map { Double($0) ?? 0 } }, toJSON: { "\($0 ?? 0)" })
		
		nr <- (map["PrNr"], stringToIntTransform)
		credits <- (map["EctsCredits"], stringToDoubleTransform)
		grade <- (map["PrNote"], stringToDoubleTransform)
		grade /= 100
	}
	
	var description: String {
		return "\nGrade:\n\tNr: \(nr)\n\tFach: \(subject)\n\tCredtis: \(credits)\n\tNote: \(grade)"
	}
	
}
