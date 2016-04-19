//
//  Dictionary.swift
//  HTWDresden
//
//  Created by Benjamin Herzog on 19/04/16.
//  Copyright © 2016 HTW Dresden. All rights reserved.
//

import Foundation

public extension Dictionary {
	init < S: SequenceType where S.Generator.Element == (Key, Value) > (_ seq: S) {
		self = [:]
		self.merge(seq)
	}

	mutating func merge < S: SequenceType where S.Generator.Element == (Key, Value) > (other: S) {
		for (k, v) in other {
			self[k] = v
		}
	}

	func mapValues<T>(op: Value -> T) -> [Key: T] {
		return [Key: T](flatMap { return ($0, op($1)) })
	}

	var urlParameterRepresentation: String {
		return reduce("") {
			"\($0)\($0.isEmpty ? "" : "&")\($1.0)=\($1.1)"
		}
	}
}
