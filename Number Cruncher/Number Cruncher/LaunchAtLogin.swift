//
//  LaunchAtLogin.swift
//  Number Cruncher
//
//  Created by Bean John on 10/9/2023.
//

import Foundation
import ServiceManagement
import os.log

public enum LaunchAtLogin {
    private static let logger = Logger(subsystem: "com.sindresorhus.LaunchAtLogin", category: "main")
    fileprivate static let observable = Observable()

    /**
    Toggle “launch at login” for your app or check whether it's enabled.
    */
    public static var isEnabled: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            observable.objectWillChange.send()

            do {
                if newValue {
                    if SMAppService.mainApp.status == .enabled {
                        try? SMAppService.mainApp.unregister()
                    }

                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                logger.error("Failed to \(newValue ? "enable" : "disable") launch at login: \(error.localizedDescription)")
            }
        }
    }
}

extension LaunchAtLogin {
    final class Observable: ObservableObject {
        var isEnabled: Bool {
            get { LaunchAtLogin.isEnabled }
            set {
                LaunchAtLogin.isEnabled = newValue
            }
        }
    }
}
