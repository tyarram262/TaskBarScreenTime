//
//  ScreenTimeTrackerApp.swift
//  ScreenTimeTracker
//
//  Created by Tanush Yarram on 12/28/24.
//

import SwiftUI

@main
struct ScreenTimeTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
            // No main window; only the menu bar app runs
            Settings { }
        }
}
