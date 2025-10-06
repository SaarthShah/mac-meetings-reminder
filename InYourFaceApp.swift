import SwiftUI

@main
struct MeetingReminderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var meetingMonitor = MeetingMonitor()
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var meetingMonitor: MeetingMonitor?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Create menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "calendar.badge.clock", accessibilityDescription: "Meeting Reminder")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About Meeting Reminder", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
        
        // Initialize meeting monitor
        meetingMonitor = MeetingMonitor()
        meetingMonitor?.requestCalendarAccess()
    }
    
    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Meeting Reminder"
        alert.informativeText = "Never Miss Critical Meetings\n\nBlocks your screen when it's time to go to the meeting."
        alert.alertStyle = .informational
        alert.runModal()
    }
}

