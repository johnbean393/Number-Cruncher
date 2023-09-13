//
//  NumberCruncherTools.swift
//  Number Cruncher
//
//  Created by Bean John on 10/9/2023.
//

import Foundation
import SwiftUI
import BezelNotification
import MathParser
import KeySender

class NumberCruncherTools {
    
    static func checkIfAccessibilityEnabled() {
        if !AXIsProcessTrusted() {
            let alert = NSAlert.init()
            alert.addButton(withTitle: "Open Security & Privacy Settings…")
            alert.messageText = "Number Cruncher Requires Accessibility Access."
            alert.informativeText = "Number Cruncher needs accessibility settings to read global keystrokes.\n\nPlease go to the Security & Privacy settings pane and check Number Cruncher under Accessibility.\n\nNumber Cruncher will not launch properly until permissions are given."
            alert.alertStyle = NSAlert.Style.critical
            alert.runModal()
            
            let p = Process()
            p.launchPath = "/usr/bin/open"
            p.arguments = ["x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]
            p.launch()
            
            NSApp.terminate(self)
        }
    }
    
    static func getDownloadsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func showBezelNotification(message: String) {
        let bezel = BezelNotification(text: message, visibleTime: 2.0)
        bezel.show()
    }
    
    static func _postKeyEvent(_ keyCode: Int, keyDown: Bool) {
        let eventSource = CGEventSource.init(stateID: CGEventSourceStateID.hidSystemState)
        let keyEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: CGKeyCode(keyCode), keyDown: keyDown)
        let loc = CGEventTapLocation.cghidEventTap
        keyEvent!.post(tap: loc)
    }
    
    static func evaluateMathExpression(expressionStr: String) throws -> Double {
        do {
            let processedExpressionStr: String = expressionStr.replacingOccurrences(of: "（", with: "(").replacingOccurrences(of: "（", with: ")").replacingOccurrences(of: "^", with: "**").replacingOccurrences(of: " ", with: "")
            let expression: Expression = try Expression(string: processedExpressionStr)
            return try Evaluator().evaluate(expression)
        } catch {
            print("Expression invalid")
            throw EvaluationError.invalid
        }
    }
    
    static func insertAnswer(answerStr: String) throws {
        do {
            // Type new characters
            let replacer: KeySender = try KeySender(for: answerStr)
            replacer.sendGlobally()
        } catch {
            KeystrokeError.invalid
        }
    }
    
    static func simplifyAnswer(answer: Double) -> String {
        if answer.isInt {
            return Int(answer).description
        } else {
            // Use number formatter to get 3 s.f.
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 3
            if let result = formatter.string(from: answer as NSNumber) {
                return result
            }
        }
        return answer.description
    }
}

