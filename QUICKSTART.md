# Quick Start Guide

## Easiest Way: Build with Xcode

1. **Open Xcode** (download from Mac App Store if you don't have it)

2. **Create New Project:**
   - File → New → Project
   - Select "App" under macOS
   - Product Name: `MeetingReminder`
   - Interface: SwiftUI
   - Language: Swift
   - Click Next and save it

3. **Replace Files:**
   - Delete the auto-generated `MeetingReminderApp.swift` and `ContentView.swift`
   - Drag these files from Finder into Xcode:
     - `MeetingReminderApp.swift`
     - `CalendarManager.swift`
     - `MeetingMonitor.swift`
     - `ReminderView.swift`
     - `SettingsManager.swift`
     - `SettingsView.swift`
   - Replace `Info.plist` with the provided one
   - Add `MeetingReminder.entitlements` to the project

4. **Configure Capabilities:**
   - Click on your project (top of file tree)
   - Select the "MeetingReminder" target
   - Go to "Signing & Capabilities" tab
   - Click "+ Capability" and add "App Sandbox"
   - Under App Sandbox, check "Calendars"

5. **Build & Run:**
   - Press **⌘R** or click the Play button
   - Grant calendar access when prompted
   - The app icon will appear in your menu bar (calendar with clock icon)

## Test It Out

1. Open **Calendar.app**
2. Create a new event that starts in **1 minute**
3. Wait... and watch your screen get taken over! 🎯

## What You'll See

**Settings Panel (click menu bar icon):**
- Choose between Light, Dark, or Auto theme
- Adjust check interval, reminder timing, snooze duration
- Customize auto-dismiss timeout
- View app version and info

**When a meeting starts:**
- Full-screen themed overlay (can't miss it!)
- Meeting title, time, and location
- Two big buttons:
  - **"I'm Going"** - Dismisses and lets you get to your meeting
  - **"Snooze X min"** - Reminds you again (time based on settings)
- Auto-dismisses based on your settings

## Tips

- **Left-click** the menu bar icon to open Settings
- **Right-click** the menu bar icon for About/Quit menu
- The app runs in the background (menu bar only)
- Only shows reminders for meetings based on your timing settings
- Skips all-day events
- Won't show the same meeting twice (unless you snooze it)
- Theme changes apply immediately to new reminders

## Troubleshooting

**No menu bar icon?**
- Make sure "LSUIElement" is set to true in Info.plist

**No reminders appearing?**
- Check System Settings → Privacy & Security → Calendars
- Make sure "Meeting Reminder" has access
- Create a test event 1 minute in the future to verify

**Want to customize?**
- Change colors, timing, behavior in the source files
- See README.md for details

Enjoy never missing a meeting again! 🎉

