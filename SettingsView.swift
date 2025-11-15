import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsManager.shared
    var onClose: (() -> Void)?
    
    // Styling
    private var cardBackground: Color { Color.white.opacity(0.05) }
    private var cardStroke: Color { Color.white.opacity(0.12) }
    private var windowBackground: LinearGradient {
        LinearGradient(
            colors: [Color.black, Color.black.opacity(0.96)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
			// Header: logo on the left, name and tagline on the right
			HStack(alignment: .center, spacing: 12) {
				Image("AppLogo", bundle: .module)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 44, height: 44)
					.shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
				
				VStack(alignment: .leading, spacing: 2) {
					Text("Dart")
						.font(.system(size: 22, weight: .bold))
						.foregroundColor(.primary)
					
					Text("Never miss an important meeting")
						.font(.system(size: 11))
						.foregroundColor(.secondary)
				}
				
				Spacer()
			}
			.padding(.horizontal, 16)
			.padding(.top, 12)
			.padding(.bottom, 8)
            
            Divider()
            
            // Settings Content
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Theme
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
                            .frame(width: 120)
                        }
                        Divider()
                            .foregroundColor(.clear)
                            .overlay(Color.white.opacity(0.08))
                            .padding(.leading, 52)
                        // Check Interval
                        SettingsRow(
                            icon: "arrow.clockwise",
                            title: "Check Interval",
                            subtitle: "\(settings.checkInterval)s"
                        ) {
                            Stepper("", value: $settings.checkInterval, in: 15...120, step: 15)
                                .labelsHidden()
                        }
                        Divider()
                            .foregroundColor(.clear)
                            .overlay(Color.white.opacity(0.08))
                            .padding(.leading, 52)
                        // Reminder lead time
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Show Reminder",
                            subtitle: "\(settings.reminderMinutesBefore) min before"
                        ) {
                            Stepper("", value: $settings.reminderMinutesBefore, in: 0...5)
                                .labelsHidden()
                        }
                        Divider()
                            .foregroundColor(.clear)
                            .overlay(Color.white.opacity(0.08))
                            .padding(.leading, 52)
                        // Auto dismiss
                        SettingsRow(
                            icon: "timer",
                            title: "Auto Dismiss",
                            subtitle: "\(settings.autoDismissSeconds)s"
                        ) {
                            Stepper("", value: $settings.autoDismissSeconds, in: 5...60, step: 5)
                                .labelsHidden()
                        }
                        Divider()
                            .foregroundColor(.clear)
                            .overlay(Color.white.opacity(0.08))
                            .padding(.leading, 52)
                        // Snooze
                        SettingsRow(
                            icon: "moon.zzz.fill",
                            title: "Snooze Duration",
                            subtitle: "\(settings.snoozeMinutes) min"
                        ) {
                            Stepper("", value: $settings.snoozeMinutes, in: 1...15)
                                .labelsHidden()
                        }
                    }
					.padding(.vertical, 8)
                    .padding(.horizontal, 16)
					.padding(.top, 8)

                    Spacer().frame(height: 20)
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
        .background(windowBackground)
    }
}

// (SectionHeader removed to keep layout minimal)

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
		.padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isHovering ? Color.white.opacity(0.04) : Color.clear)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

#Preview {
    SettingsView()
}
