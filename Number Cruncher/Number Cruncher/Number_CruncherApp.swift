//
//  Number_CruncherApp.swift
//  Number Cruncher
//
//  Created by Bean John on 10/9/2023.
//

import SwiftUI

@main
struct Number_CruncherApp: App {
    
    init() {
        NumberCruncherTools.checkIfAccessibilityEnabled()
        LaunchAtLogin.isEnabled = true
    }
    
    @StateObject var numberCruncherMonitor: NumberCruncherMonitor = NumberCruncherMonitor()
    @State var launchState: Bool = LaunchAtLogin.isEnabled
    
    var body: some Scene {
        MenuBarExtra("Number Cruncher", systemImage: "plus.forwardslash.minus") {
            ContentView(numberCruncherMonitor: numberCruncherMonitor, launchState: $launchState)
        }
        .menuBarExtraStyle(.menu)
    }
    
}
