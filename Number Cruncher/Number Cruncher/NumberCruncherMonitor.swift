//
//  NumberCruncherMonitor.swift
//  Number Cruncher
//
//  Created by Bean John on 10/9/2023.
//

import Foundation
import SwiftUI

class NumberCruncherMonitor: ObservableObject {
    
    @Published var storedKeystrokes: String = ""
    @Published var monitorEnabled: Bool = false
    var keyMonitor: Any?
    var clickMonitor: Any?
    var stringWorkingIndex: Int = 0
    
    init() {
        enableMonitor()
    }
    
    func enableMonitor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.keyMonitor = NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: self.onGlobalKeyDown)!
            self.clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.leftMouseDown, handler: { _ in
                self.storedKeystrokes = ""
                self.stringWorkingIndex = 0
            })!
            print("Added monitor")
        }
        monitorEnabled = true
    }
    
    func resetVariables() {
        storedKeystrokes = ""
        stringWorkingIndex = 0
    }

    func onGlobalKeyDown(_ event: NSEvent) {
        let newText: String = event.characters!
        // Handle key
        print(event.modifierFlags)
        if [NSEvent.ModifierFlags(rawValue: 8388864), NSEvent.ModifierFlags(rawValue: 11010336), NSEvent.ModifierFlags(rawValue: 11010368), NSEvent.ModifierFlags(rawValue: 1048848), NSEvent.ModifierFlags(rawValue: 1048840)].contains(event.modifierFlags) {
            resetVariables()
        } else {
            switch event.keyCode {
            case 123:
                // Left arrow
                stringWorkingIndex = [stringWorkingIndex + 1, storedKeystrokes.count].min()!
                print("Left arrow pressed")
            case 124:
                // Right arrow
                stringWorkingIndex = [stringWorkingIndex - 1, 0].max()!
                print("Right arrow pressed")
            case 125:
                // Down arrow
                resetVariables()
                print("Down arrow pressed")
            case 126:
                // Up arrow
                resetVariables()
                print("Up arrow pressed")
            case 36:
                // Return key
                resetVariables()
                print("Return key pressed")
            case 51:
                storedKeystrokes = String(storedKeystrokes.dropLast(1))
                print("Delete key pressed")
            default:
                // Store keystrokes
                let insertIndex = storedKeystrokes.index(storedKeystrokes.endIndex, offsetBy: -stringWorkingIndex)
                storedKeystrokes.insert(contentsOf: newText, at: insertIndex)
                storedKeystrokes = String(storedKeystrokes.suffix(100))
                // Evaluate expression
                if newText == "=" {
                    for index in 0...(storedKeystrokes.count - 1) {
                        let expressionStr: String = String(String(storedKeystrokes.dropLast(1)).suffix(storedKeystrokes.count - index))
                        do {
                            // Evaluate expression
                            let answer: Double = try NumberCruncherTools.evaluateMathExpression(expressionStr: expressionStr)
                            // If answer calculated
                            do {
                                // Print successful expression
                                print(expressionStr)
                                // Enter simplified answer
                                try NumberCruncherTools.insertAnswer(answerStr: NumberCruncherTools.simplifyAnswer(answer: answer))
                                // If replacement successful, show alert
                                NumberCruncherTools.showBezelNotification(message: "Expression Evaluated")
                                // Reset variables
                                resetVariables()
                                // End look
                                break
                            } catch {
                                print(error)
                            }
                        } catch {
                            // If evaluation failed, continue looping
                            continue
                        }
                    }
                    // Reset variables
                    resetVariables()
                }
            }
        }
    }
    
    func disableMonitor() {
        NSEvent.removeMonitor(keyMonitor!)
        monitorEnabled = false
    }
    
}
