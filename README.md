# Dart - Never Miss Critical Meetings

**Never Miss Critical Meetings**

Dart is a native macOS app that blocks your screen when it's time to go to your meeting. No more missing meetings because you got distracted!

## Features

- 🎯 **Hard to Ignore**: Full-screen overlay that you can't miss
- 📅 **Calendar Integration**: Automatically syncs with your Mac's Calendar app
- ⏰ **Perfect Timing**: Shows reminders right when meetings start
- 🔔 **Snooze Function**: Need more time? Customizable snooze duration
- 🎨 **Light & Dark Themes**: Choose between light, dark, or system theme
- ⚙️ **Customizable Settings**: Dropdown panel from menu bar icon
- 🚫 **No Distractions**: Lives in your menu bar, stays out of your way

## Requirements

- macOS 13.0 (Ventura) or later
- Access to Calendar app (you'll be prompted on first launch)

## Building the App

### Using Xcode

1. **Create a new Xcode project:**
   - Open Xcode
   - File > New > Project
   - Choose "App" under macOS
   - Name it "Dart"
   - Interface: SwiftUI
   - Language: Swift

2. **Add the source files:**
   - Replace the auto-generated files with these files:
     - `MeetingReminderApp.swift`
     - `CalendarManager.swift`
     - `MeetingMonitor.swift`
     - `ReminderView.swift`
     - `SettingsManager.swift`
     - `SettingsView.swift`

3. **Configure the project:**
   - Select your project in the navigator
   - Go to "Signing & Capabilities"
   - Add "App Sandbox" capability
   - Under App Sandbox, enable:
     - Calendar access
   - Replace Info.plist with the provided one
   - Add the entitlements file to your project

4. **Build and Run:**
   - Press Cmd+R to build and run
   - Grant calendar access when prompted

### Using command line (Swift Package Manager)

The `Package.swift` file is already included. Build with:

```bash
cd /Users/saarthshah/Desktop/Dev/meeting_reminder
swift build -c release
```

## How It Works

1. **Background Monitoring**: The app checks your calendar at your chosen interval
2. **Meeting Detection**: When a meeting is about to start (configurable timing)
3. **Screen Takeover**: A full-screen themed overlay appears with meeting details
4. **Your Choice**: 
   - Click "I'm Going" to dismiss and get to your meeting
   - Click "Snooze" to postpone the reminder (customizable duration)
   - Wait for auto-dismiss (configurable timeout)

## Settings

Click the menu bar icon to access settings:

- **Theme**: Choose Light, Dark, or System
- **Check Interval**: How often to check calendar (15-120 seconds)
- **Reminder Time**: When to show reminder (0-5 minutes before meeting)
- **Auto Dismiss**: How long before auto-closing (5-60 seconds)
- **Snooze Duration**: How long to snooze (1-15 minutes)

Right-click the menu bar icon for quick access to About and Quit options.

## Privacy

- All calendar data stays on your Mac
- No internet connection required
- No data collection or tracking
- Your meetings are your business!

## Customization

All customization is now available through the Settings panel! Just click the menu bar icon to adjust:

- Check interval, reminder timing, auto-dismiss duration, snooze duration
- Theme selection (Light/Dark/System)

Advanced users can still modify `SettingsManager.swift` to change default values or add new settings.

## Troubleshooting

**Calendar access denied?**
- Go to System Settings > Privacy & Security > Calendars
- Enable access for "Dart"

**Not showing reminders?**
- Check that you have events in your calendar
- Make sure events are not all-day events
- Verify the app is running (look for the icon in menu bar)

**Want to test it?**
- Create a test event in Calendar app that starts in 1 minute
- Wait for the reminder to appear!

## License

MIT License - Feel free to modify and use as you wish!

## Credits

Inspired by the need to stay focused and never miss important meetings. Perfect for anyone who gets easily distracted or needs a hard-to-ignore reminder system.

# mac-meetings-reminder
