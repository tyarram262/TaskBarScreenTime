import Cocoa

// Define the AppUsage struct at the top of the file
struct AppUsage {
    let appName: String
    var duration: TimeInterval
}
let targetApps = ["Safari", "Spotify", "Xcode"] // Add more app names here


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
        var activeAppName: String?
        var appStartTime: Date?
        var appUsage: [String: TimeInterval] = [:]

        func applicationDidFinishLaunching(_ notification: Notification) {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            if let button = statusItem?.button {
                button.title = "Screen Time"
                button.action = #selector(showMenu)
            }

            // Start tracking active apps
            trackActiveApplication()
        }
    func trackActiveApplication() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(activeApplicationDidChange),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )
    }

    @objc func activeApplicationDidChange(notification: Notification) {
        let workspace = NSWorkspace.shared
        if let currentApp = workspace.frontmostApplication?.localizedName {
            
            // Check if the current app is in the list of target apps
            if targetApps.contains(currentApp) {
                // Update time for the previous active app
                if let activeAppName = activeAppName, let startTime = appStartTime {
                    print("Current App: \(currentApp), Active App: \(activeAppName ?? "None"), Duration: \(Date().timeIntervalSince(startTime ?? Date())) seconds")
                    let duration = Date().timeIntervalSince(startTime)
                    appUsage[activeAppName, default: 0] += duration
                }

                // Update active app and start time
                activeAppName = currentApp
                appStartTime = Date()
            } else {
                // Reset tracking for non-target apps
                if let activeAppName = activeAppName, targetApps.contains(activeAppName) {
                    let duration = Date().timeIntervalSince(appStartTime ?? Date())
                    appUsage[activeAppName, default: 0] += duration
                }
                activeAppName = nil
                appStartTime = nil
            }
            
        }

    }



    @objc func showMenu() {
        // Update time for the current active app
            print("Menu Updated - App Usage: \(appUsage)")


        if let activeAppName = activeAppName, let startTime = appStartTime, targetApps.contains(activeAppName) {
            let duration = Date().timeIntervalSince(startTime)
            appUsage[activeAppName, default: 0] += duration
            appStartTime = Date()
            
        }

        // Create the menu
        let menu = NSMenu()

        // Add screen time stats for target apps
        targetApps.forEach { appName in
            let duration = appUsage[appName, default: 0]
            let timeInMinutes = Int(duration / 60)
            menu.addItem(NSMenuItem(title: "\(appName): \(timeInMinutes) minutes", action: nil, keyEquivalent: ""))
        }

        // Add a separator and a quit option
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))

        // Set the menu to the status item
        statusItem?.menu = menu
            if let activeAppName = activeAppName, targetApps.contains(activeAppName) {
                let duration = Date().timeIntervalSince(appStartTime ?? Date())
                appUsage[activeAppName, default: 0] += duration
            }
            appStartTime = nil
            activeAppName = nil
            statusItem?.menu = menu
        
    }



    @objc func quitApp() {
        if let activeAppName = activeAppName, let startTime = appStartTime, targetApps.contains(activeAppName) {
            let duration = Date().timeIntervalSince(startTime)
            appUsage[activeAppName, default: 0] += duration
        }
        NSApplication.shared.terminate(self)
    }


}
