import Foundation
import EventKit
import SwiftUI

class MeetingMonitor: ObservableObject {
    private let calendarManager = CalendarManager()
    private var timer: Timer?
    private var shownEventIDs = Set<String>()
    private let settings = SettingsManager.shared
    
    init() {
        startMonitoring()
        
        // Restart monitoring when settings change
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartMonitoring),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func restartMonitoring() {
        timer?.invalidate()
        startMonitoring()
    }
    
    func requestCalendarAccess() {
        Task {
            let granted = await calendarManager.requestAccess()
            if granted {
                print("Calendar access granted")
            } else {
                print("Calendar access denied")
                await showAccessDeniedAlert()
            }
        }
    }
    
    private func startMonitoring() {
        // Check based on user settings
        let interval = TimeInterval(settings.checkInterval)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.checkForMeetings()
        }
        timer?.tolerance = 5.0
        
        // Initial check
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkForMeetings()
        }
    }
    
    private func checkForMeetings() {
        let events = calendarManager.getEventsStartingNow(minutesBefore: settings.reminderMinutesBefore)
        
        for event in events {
            guard let eventID = event.eventIdentifier,
                  !shownEventIDs.contains(eventID) else {
                continue
            }
            
            // Mark as shown
            shownEventIDs.insert(eventID)
            
            // Show the reminder
            Task { @MainActor in
                self.showReminderWindow(for: event)
            }
            
            // Clean up old event IDs after 2 hours
            DispatchQueue.main.asyncAfter(deadline: .now() + 7200) {
                self.shownEventIDs.remove(eventID)
            }
        }
    }
    
    @MainActor
    private func showReminderWindow(for event: EKEvent) {
        let reminderView = ReminderView(event: event)
        let hostingController = NSHostingController(rootView: reminderView)
        
        let window = NSWindow(contentViewController: hostingController)
        window.styleMask = [.borderless, .fullSizeContentView]
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isOpaque = false
        window.backgroundColor = .clear
        window.ignoresMouseEvents = false
        
        // Make it full screen
        if let screen = NSScreen.main {
            window.setFrame(screen.frame, display: true)
        }
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
    private func showAccessDeniedAlert() {
        let alert = NSAlert()
        alert.messageText = "Calendar Access Required"
        alert.informativeText = "Meeting Reminder needs access to your calendar to show meeting reminders. Please grant access in System Settings > Privacy & Security > Calendars."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Settings")
        alert.addButton(withTitle: "Cancel")
        
        if alert.runModal() == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars") {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

