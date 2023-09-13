//
//  Constants.swift
//  Number Cruncher
//
//  Created by Bean John on 10/9/2023.
//

import Foundation

enum EvaluationError: Error {
    case invalid
}

enum KeystrokeError: Error {
    case invalid
}

extension FloatingPoint {
    var isInt: Bool {
        return floor(self) == self
    }
}
