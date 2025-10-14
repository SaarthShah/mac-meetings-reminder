import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case auto = "System"
    
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
                background: Color.black,
                primary: Color.white,
                text: Color.white,
                secondaryText: Color.white.opacity(0.7),
                buttonBackground: Color(white: 0.15),
                buttonText: Color.white
            )
        } else {
            return ThemeColors(
                background: Color.white,
                primary: Color.black,
                text: Color.black,
                secondaryText: Color.black.opacity(0.6),
                buttonBackground: Color(white: 0.95),
                buttonText: Color.black
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
