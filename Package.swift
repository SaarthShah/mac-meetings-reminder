// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Dart",
    platforms: [.macOS(.v13)],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Dart",
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

