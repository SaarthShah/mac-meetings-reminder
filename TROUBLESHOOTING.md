# Troubleshooting Guide

## Menu Bar Icon Not Showing

### Quick Checks:

1. **Is the app running?**
   - The app won't appear in your Dock (by design)
   - Look in the **top-right corner** of your screen in the menu bar
   - You should see a calendar icon with a clock badge

2. **Build and Run in Xcode:**
   ```
   - Open the project in Xcode
   - Press ⌘R (Command + R) to build and run
   - Check the Xcode console for any errors
   - Look for "Calendar access granted" message
   ```

3. **Check Activity Monitor:**
   - Open Activity Monitor (Applications > Utilities)
   - Search for "MeetingReminder" or "Meeting Reminder"
   - If it's running, you should see it in the list

4. **If the app is running but no icon appears:**
   - The icon might be hidden if your menu bar is too crowded
   - Try hiding some other menu bar apps
   - Or look for the icon on the far right

### Common Issues:

#### Issue 1: App Won't Build
**Error:** "Cannot find 'X' in scope"
- Make sure ALL source files are added to your Xcode project:
  - MeetingReminderApp.swift
  - CalendarManager.swift
  - MeetingMonitor.swift
  - ReminderView.swift
  - SettingsManager.swift
  - SettingsView.swift

#### Issue 2: App Crashes on Launch
**Check:**
1. Info.plist has correct calendar permission strings
2. MeetingReminder.entitlements is added to project
3. App Sandbox capability is enabled with Calendar access

#### Issue 3: Menu Bar Icon is There But Nothing Happens
**Try:**
- Left-click the icon → Should open Settings panel
- Right-click the icon → Should show menu
- Check Console.app for error messages

### Step-by-Step Xcode Setup:

1. **Create Xcode Project:**
   ```
   File → New → Project
   Choose: macOS → App
   Product Name: MeetingReminder
   Interface: SwiftUI
   Language: Swift
   ```

2. **Delete Default Files:**
   - Right-click on `ContentView.swift` → Delete → Move to Trash
   - Right-click on auto-generated `MeetingReminderApp.swift` if it exists → Delete

3. **Add Source Files:**
   - Drag all .swift files from Finder into Xcode project navigator
   - When prompted, check "Copy items if needed"
   - Make sure they're added to the "MeetingReminder" target

4. **Add Configuration Files:**
   - Drag `Info.plist` to project root
   - Right-click project → Add Files → Add `MeetingReminder.entitlements`
   - OR create entitlements: Click project → Signing & Capabilities → + Capability → App Sandbox

5. **Configure Entitlements:**
   - Select project in navigator
   - Select "MeetingReminder" target
   - Go to "Signing & Capabilities" tab
   - Under "App Sandbox", enable:
     ☑️ Calendars
   - The entitlements file should now show:
     ```xml
     <key>com.apple.security.app-sandbox</key>
     <true/>
     <key>com.apple.security.personal-information.calendars</key>
     <true/>
     ```

6. **Build Settings:**
   - Make sure "Info.plist File" points to your Info.plist
   - Make sure "Code Signing Entitlements" points to MeetingReminder.entitlements

7. **Build and Run:**
   - Press ⌘R
   - Grant calendar permission when prompted
   - Look in menu bar for calendar icon

### Still Not Working?

**Check Xcode Console Output:**
```
Look for these messages:
✅ "Calendar access granted" - Good!
❌ "Calendar access denied" - Need to grant permissions
❌ Any Swift errors - Check your source files
```

**Verify File Structure in Xcode:**
```
MeetingReminder/
├── MeetingReminderApp.swift
├── CalendarManager.swift
├── MeetingMonitor.swift
├── ReminderView.swift
├── SettingsManager.swift
├── SettingsView.swift
├── Info.plist
└── MeetingReminder.entitlements
```

**Manual Permission Check:**
1. Open System Settings
2. Go to Privacy & Security → Calendars
3. Look for "MeetingReminder" in the list
4. Make sure it's enabled (checkbox checked)

### Testing the App:

Once the menu bar icon appears:

1. **Left-click the icon**
   - Settings panel should drop down
   - You should see theme options and timing settings

2. **Right-click the icon**
   - Context menu should appear
   - Options: Settings, About, Quit

3. **Create a test meeting**
   - Open Calendar.app
   - Create event starting in 1 minute
   - Wait for the full-screen reminder to appear

### Screenshot Locations:

The menu bar is at the **top of your screen**:
```
┌─────────────────────────────────────────────────┐
│  Menu Bar Items → → → → 🗓️ [Your icon here!]   │
└─────────────────────────────────────────────────┘
```

Look for a calendar icon with a small clock badge in the top-right area, near the time/date, WiFi, battery icons, etc.

### Need More Help?

If you're still stuck, check:
1. Xcode Build Output for specific errors
2. Console.app for runtime logs (search for "MeetingReminder")
3. Make sure macOS version is 13.0 (Ventura) or later
