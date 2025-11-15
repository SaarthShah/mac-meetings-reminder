// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MeetingReminder",
    platforms: [.macOS(.v13)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MeetingReminder",
            dependencies: [],
            path: ".",
            sources: [
                "MeetingReminderApp.swift",
                "CalendarManager.swift", 
                "MeetingMonitor.swift",
                "ReminderView.swift",
                "SettingsManager.swift",
                "SettingsView.swift"
            ],
            resources: [
                .process("Assets.xcassets"),
                .copy("DartIcon.icns")
            ]
        )
    ]
)

