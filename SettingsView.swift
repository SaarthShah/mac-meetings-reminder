import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsManager.shared
    var onClose: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // App Title
            VStack(spacing: 8) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 32))
                    .foregroundColor(.primary)
                
                Text("Meeting Reminder")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Never miss an important meeting")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 32)
            .padding(.bottom, 24)
            
            Divider()
            
            // Settings Content
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Appearance Section
                    VStack(alignment: .leading, spacing: 0) {
                        SectionHeader(title: "Appearance")
                        
                        SettingsRow(
                            icon: "paintbrush.fill",
                            title: "Theme",
                            subtitle: "Changes the color scheme of the reminder overlay"
                        ) {
                            Picker("", selection: $settings.selectedTheme) {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    Text(theme.displayName).tag(theme)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 100)
                        }
                    }
                    
                    Divider()
                        .padding(.leading, 52)
                    
                    // Timing Section
                    VStack(alignment: .leading, spacing: 0) {
                        SectionHeader(title: "Timing")
                        
                        SettingsRow(
                            icon: "arrow.clockwise",
                            title: "Check Interval",
                            subtitle: "\(settings.checkInterval)s"
                        ) {
                            Stepper("", value: $settings.checkInterval, in: 15...120, step: 15)
                                .labelsHidden()
                        }
                        
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Show Reminder",
                            subtitle: "\(settings.reminderMinutesBefore) min before"
                        ) {
                            Stepper("", value: $settings.reminderMinutesBefore, in: 0...5)
                                .labelsHidden()
                        }
                        
                        SettingsRow(
                            icon: "timer",
                            title: "Auto Dismiss",
                            subtitle: "\(settings.autoDismissSeconds)s"
                        ) {
                            Stepper("", value: $settings.autoDismissSeconds, in: 5...60, step: 5)
                                .labelsHidden()
                        }
                        
                        SettingsRow(
                            icon: "moon.zzz.fill",
                            title: "Snooze Duration",
                            subtitle: "\(settings.snoozeMinutes) min"
                        ) {
                            Stepper("", value: $settings.snoozeMinutes, in: 1...15)
                                .labelsHidden()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 20)
                }
            }
            
            // Footer
            VStack(spacing: 4) {
                Divider()
                
                Text("Built by Saarth Shah")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.6))
                    .padding(.vertical, 12)
            }
        }
        .frame(width: 420, height: 600)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .kerning(0.5)
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 10)
    }
}

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content?
    @State private var isHovering = false
    
    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    init(icon: String, title: String, subtitle: String) where Content == EmptyView {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = nil
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(width: 18)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let content = content {
                content
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 10)
        .background(isHovering ? Color.secondary.opacity(0.05) : Color.clear)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    SettingsView()
}
