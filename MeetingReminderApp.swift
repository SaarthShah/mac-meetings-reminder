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
    var settingsPopover: NSPopover?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock
        NSApp.setActivationPolicy(.accessory)
        
        // Create menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "calendar.badge.clock", accessibilityDescription: "Meeting Reminder")
            button.action = #selector(statusBarButtonClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Initialize meeting monitor
        meetingMonitor = MeetingMonitor()
        meetingMonitor?.requestCalendarAccess()
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            toggleSettingsPopover(sender)
        }
    }
    
    func showContextMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "About Meeting Reminder", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
        statusItem?.menu = nil
    }
    
    @objc func toggleSettingsPopover(_ sender: NSStatusBarButton) {
        if let popover = settingsPopover, popover.isShown {
            popover.close()
            return
        }
        
        showSettings()
    }
    
    @objc func showSettings() {
        guard let button = statusItem?.button else { return }
        
        if settingsPopover == nil {
            settingsPopover = NSPopover()
            settingsPopover?.behavior = .transient
            settingsPopover?.animates = true
        }
        
        let settingsView = SettingsView(onClose: { [weak self] in
            self?.settingsPopover?.close()
        })
        let hostingController = NSHostingController(rootView: settingsView)
        
        settingsPopover?.contentViewController = hostingController
        settingsPopover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Meeting Reminder"
        alert.informativeText = "Never Miss Critical Meetings\n\nBlocks your screen when it's time to go to the meeting."
        alert.alertStyle = .informational
        alert.runModal()
    }
}

