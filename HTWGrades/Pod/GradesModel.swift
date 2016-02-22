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

	var settings: Settings

	init(settings: Settings) {
		self.settings = settings
	}

	func start(completion: ([String: [Grade]] -> Void)? = nil) {

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

					completion?(self.groupGrades(grades))
				}
			}
		}
	}

	private func groupGrades(grades: [Grade]) -> [String: [Grade]] {

		var result = [String: [Grade]]()

		for grade in grades {

			if result[grade.semester] == nil {
				result[grade.semester] = []
			}

			result[grade.semester]?.append(grade)
		}

		return result
	}

	private func loadCourses(completion: (success: Bool, data: [Course]) -> Void) {

		guard let u = settings.sNumber, let p = settings.password else {
			print("Set a user first!!")
			return
		}

		Alamofire.request(.POST, getPos, parameters: ["sNummer": u, "RZLogin": p])
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

		guard let u = settings.sNumber, let p = settings.password else {
			print("Set a user first!!")
			return
		}

		Alamofire.request(.POST, getGrade, parameters: ["sNummer": u, "RZLogin": p, "AbschlNr": course.AbschlNr, "POVersion": course.POVersion, "StgNr": course.StgNr])
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

	static func getAverage(grades: [[Grade]]) -> Double {

		let semesterAverages = grades.map {
			semester -> Double in

			let allCredits = semester.reduce(0.0) { $0 + $1.credits }
			let allWeightedGrades = semester.reduce(0.0) { $0 + ($1.credits * $1.grade) }

			return allWeightedGrades / allCredits
		}

		return semesterAverages.reduce(0.0, combine: +) / Double(semesterAverages.count)
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
	var semesterjahr: Int = 0

	init?(_ map: Map) {

		subject = map["PrTxt"].valueOr("")
		state = map["Status"].valueOr("")
		semester = map["Semester"].valueOrFail()
		semesterjahr = Int(String(semester.characters.dropLast()))!
		semester = String(semester.characters.dropFirst(4))

		if (semester == "1") {
			semester = "Sommersemester \(semesterjahr)"
		}
		else {
			semester = "Wintersemester \(semesterjahr)/" + String(String(semesterjahr + 1).characters.dropFirst(2))
		}

		if !map.isValid {
			return nil
		}
	}

	mutating func mapping(map: Map) {
		let stringToIntTransform = TransformOf<Int, String>(fromJSON: { $0.map { Int($0) ?? 0} }, toJSON: { "\($0 ?? 0)"})
		let stringToDoubleTransform = TransformOf<Double, String>(fromJSON: { $0.map { Double($0) ?? 0} }, toJSON: { "\($0 ?? 0)"})

		nr <- (map["PrNr"], stringToIntTransform)
		credits <- (map["EctsCredits"], stringToDoubleTransform)
		grade <- (map["PrNote"], stringToDoubleTransform)
		grade /= 100
	}

	var description: String {
		return "\nGrade:\n\tNr: \(nr)\n\tFach: \(subject)\n\tCredtis: \(credits)\n\tNote: \(grade)"
	}
}
