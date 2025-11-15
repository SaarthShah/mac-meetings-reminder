import SwiftUI
import ServiceManagement
import AppKit

@main
struct MeetingReminderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var meetingMonitor = MeetingMonitor()
    
    var body: some Scene {
        WindowGroup {
            SettingsView()
                .frame(minWidth: 420, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Dart") {
                    appDelegate.showAbout()
                }
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var meetingMonitor: MeetingMonitor?
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Show in Dock as a regular app
        NSApp.setActivationPolicy(.regular)

        // Set Dock icon from packaged resources (black background logo)
        if let iconURL = Bundle.module.url(forResource: "DartIcon", withExtension: "icns"),
           let iconImage = NSImage(contentsOf: iconURL) {
            // Apply rounded corners only for Dock icon
            let radius = min(iconImage.size.width, iconImage.size.height) * 0.18
            let rounded = makeRoundedImage(from: iconImage, cornerRadius: radius)
            NSApplication.shared.applicationIconImage = rounded
        }
        
        // Create menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Load spiral logo from SwiftPM bundle; fall back to 16x16 icon
            let statusImage = Bundle.module.image(forResource: "AppLogo") ??
                               Bundle.module.image(forResource: "icon_16x16")
            if let statusImage = statusImage {
                statusImage.size = NSSize(width: 18, height: 18)
                statusImage.isTemplate = true // allow automatic tinting in menu bar
                button.image = statusImage
            }
        }
        
        updateMenu()
        
        // Initialize meeting monitor
        meetingMonitor = MeetingMonitor()
        meetingMonitor?.requestCalendarAccess()
        
        // Listen for launch at login changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateMenu),
            name: NSNotification.Name("LaunchAtLoginChanged"),
            object: nil
        )
    }
    
    // Produce an NSImage with rounded corners
    private func makeRoundedImage(from image: NSImage, cornerRadius: CGFloat) -> NSImage {
        let targetSize = image.size
        let newImage = NSImage(size: targetSize)
        newImage.lockFocus()
        let rect = NSRect(origin: .zero, size: targetSize)
        NSGraphicsContext.current?.imageInterpolation = .high
        let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
        path.addClip()
        image.draw(in: rect)
        newImage.unlockFocus()
        return newImage
    }
    
    @objc func updateMenu() {
        let menu = NSMenu()
        
        // Open Settings
        menu.addItem(NSMenuItem(
            title: "Open Settings",
            action: #selector(openSettings),
            keyEquivalent: ","
        ))
        
        menu.addItem(NSMenuItem.separator())
        
        // Launch at Login toggle
        let launchAtLoginItem = NSMenuItem(
            title: "Launch at Login",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchAtLoginItem.state = isLaunchAtLoginEnabled() ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        menu.addItem(NSMenuItem(
            title: "Quit Dart",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
        
        statusItem?.menu = menu
    }
    
    @objc func openSettings() {
        NSApp.activate(ignoringOtherApps: true)
        
        // Bring the main window to front
        if let window = NSApp.windows.first(where: { $0.isVisible && !$0.isSheet }) {
            window.makeKeyAndOrderFront(nil)
        }
    }
    
    @objc func toggleLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            if isLaunchAtLoginEnabled() {
                try? SMAppService.mainApp.unregister()
            } else {
                try? SMAppService.mainApp.register()
            }
        }
        updateMenu()
    }
    
    func isLaunchAtLoginEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }
    
    func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Dart"
        alert.informativeText = "Never Miss Critical Meetings\n\nVersion 1.0\nBuilt by Saarth Shah\n\nBlocks your screen when it's time to go to the meeting."
        alert.alertStyle = .informational
        alert.runModal()
    }
}

