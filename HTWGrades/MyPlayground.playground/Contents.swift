//: Playground - noun: a place where people can play

import Cocoa

struct Grade {
	
	var credits: Double = 0
	var grade: Double = 0
}

func getAverage(grades: [[Grade]]) -> Double {
	
	let semesterAverages = grades.map {
		semester -> Double in
		
		let allCredits = semester.reduce(0) { $0 + $1.credits }
		let allWeightedGrades = semester.reduce(0) { $0 + ($1.credits * $1.grade) }
		
		return allWeightedGrades / allCredits
	}
	
	return semesterAverages.reduce(0.0, combine: +) / Double(semesterAverages.count)
}

let a = Grade(credits: 5, grade: 2.3)
let b = Grade(credits: 4, grade: 1.7)

let c = [[a,b], [a,b], [a], [b]]

getAverage(c)