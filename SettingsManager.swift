import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto (System)"
    
    var displayName: String {
        return self.rawValue
    }
}

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    @Published var checkInterval: Int {
        didSet {
            UserDefaults.standard.set(checkInterval, forKey: "checkInterval")
        }
    }
    
    @Published var reminderMinutesBefore: Int {
        didSet {
            UserDefaults.standard.set(reminderMinutesBefore, forKey: "reminderMinutesBefore")
        }
    }
    
    @Published var autoDismissSeconds: Int {
        didSet {
            UserDefaults.standard.set(autoDismissSeconds, forKey: "autoDismissSeconds")
        }
    }
    
    @Published var snoozeMinutes: Int {
        didSet {
            UserDefaults.standard.set(snoozeMinutes, forKey: "snoozeMinutes")
        }
    }
    
    private init() {
        let themeString = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.auto.rawValue
        self.selectedTheme = AppTheme(rawValue: themeString) ?? .auto
        
        self.checkInterval = UserDefaults.standard.integer(forKey: "checkInterval") != 0 
            ? UserDefaults.standard.integer(forKey: "checkInterval") : 30
        
        self.reminderMinutesBefore = UserDefaults.standard.integer(forKey: "reminderMinutesBefore") != 0
            ? UserDefaults.standard.integer(forKey: "reminderMinutesBefore") : 1
        
        self.autoDismissSeconds = UserDefaults.standard.integer(forKey: "autoDismissSeconds") != 0
            ? UserDefaults.standard.integer(forKey: "autoDismissSeconds") : 10
        
        self.snoozeMinutes = UserDefaults.standard.integer(forKey: "snoozeMinutes") != 0
            ? UserDefaults.standard.integer(forKey: "snoozeMinutes") : 5
    }
    
    func getThemeColors() -> ThemeColors {
        let isDark: Bool
        
        switch selectedTheme {
        case .light:
            isDark = false
        case .dark:
            isDark = true
        case .auto:
            isDark = NSApp.effectiveAppearance.name == .darkAqua
        }
        
        if isDark {
            return ThemeColors(
                background: Color(red: 0.15, green: 0.15, blue: 0.18),
                primary: Color(red: 1.0, green: 0.6, blue: 0.2),
                text: Color.white,
                secondaryText: Color.white.opacity(0.8),
                buttonBackground: Color(red: 0.25, green: 0.25, blue: 0.28),
                buttonText: Color.white
            )
        } else {
            return ThemeColors(
                background: Color(red: 1.0, green: 0.6, blue: 0.2),
                primary: Color.white,
                text: Color.white,
                secondaryText: Color.white.opacity(0.9),
                buttonBackground: Color.white,
                buttonText: Color.orange
            )
        }
    }
}

struct ThemeColors {
    let background: Color
    let primary: Color
    let text: Color
    let secondaryText: Color
    let buttonBackground: Color
    let buttonText: Color
}
