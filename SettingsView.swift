import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsManager.shared
    @Environment(\.dismiss) private var dismiss
    var onClose: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    onClose?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Settings Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Appearance Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Appearance")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Theme")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Picker("", selection: $settings.selectedTheme) {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    Text(theme.displayName).tag(theme)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        Text("Changes the color scheme of the reminder overlay")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Timing Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Timing")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        // Check Interval
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Check Interval")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text("\(settings.checkInterval) seconds")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Stepper("", value: $settings.checkInterval, in: 15...120, step: 15)
                        }
                        
                        // Reminder Time
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Show Reminder")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text("\(settings.reminderMinutesBefore) minute(s) before")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Stepper("", value: $settings.reminderMinutesBefore, in: 0...5)
                        }
                        
                        // Auto Dismiss
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Auto Dismiss")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text("\(settings.autoDismissSeconds) seconds")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Stepper("", value: $settings.autoDismissSeconds, in: 5...60, step: 5)
                        }
                        
                        // Snooze Duration
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Snooze Duration")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                Text("\(settings.snoozeMinutes) minutes")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Stepper("", value: $settings.snoozeMinutes, in: 1...15)
                        }
                    }
                    
                    Divider()
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("Meeting Reminder v1.0")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text("Never Miss Critical Meetings. Built by Saarth Shah")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(20)
            }
        }
        .frame(width: 360, height: 480)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

#Preview {
    SettingsView()
}
