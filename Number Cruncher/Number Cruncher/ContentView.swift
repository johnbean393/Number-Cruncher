//
//  ContentView.swift
//  Number Cruncher
//
//  Created by Bean John on 10/9/2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var numberCruncherMonitor: NumberCruncherMonitor
    @Binding var launchState: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Number Cruncher")
                .bold()
                .font(.title3)
            Divider()
            Button("Reset Cruncher") {
                numberCruncherMonitor.resetVariables()
            }
            Button(numberCruncherMonitor.monitorEnabled ? "Disable Cruncher" : "Enable Cruncher") {
                if !numberCruncherMonitor.monitorEnabled {
                    numberCruncherMonitor.enableMonitor()
                } else {
                    numberCruncherMonitor.disableMonitor()
                }
            }
            Button((launchState ? "Remove from" : "Add to") + " Login Items") {
                // Toggle launch at login
                LaunchAtLogin.isEnabled.toggle()
                launchState.toggle()
            }
            Divider()
            Button("Quit") {
                // Quit application
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding()
    }
    
}
