import SwiftUI
import EventKit

struct ReminderView: View {
    let event: EKEvent
    @State private var window: NSWindow?
    @State private var countdown: Int
    @State private var timer: Timer?
    @ObservedObject private var settings = SettingsManager.shared
    
    init(event: EKEvent) {
        self.event = event
        self._countdown = State(initialValue: SettingsManager.shared.autoDismissSeconds)
    }
    
    var body: some View {
        let colors = settings.getThemeColors()
        
        ZStack {
            // Background with theme
            colors.background
                .opacity(0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Icon
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 80))
                    .foregroundColor(colors.text)
                    .padding(.bottom, 20)
                
                // Title
                Text(event.title ?? "Meeting")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(colors.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Time
                VStack(spacing: 8) {
                    Text(timeString(from: event.startDate, to: event.endDate))
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(colors.secondaryText)
                    
                    if let location = event.location, !location.isEmpty {
                        HStack {
                            Image(systemName: "location.fill")
                            Text(location)
                        }
                        .font(.system(size: 24))
                        .foregroundColor(colors.secondaryText)
                    }
                }
                
                // Time display
                Text("Meeting is starting NOW!")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(colors.text)
                    .padding(.top, 20)
                
                Spacer()
                
                // Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        snooze()
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Snooze \(settings.snoozeMinutes) min")
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(colors.buttonText)
                        .frame(width: 220, height: 60)
                        .background(colors.buttonBackground)
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colors.primary, lineWidth: 2)
                    )
                    
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("I'm Going")
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(colors.text)
                        .frame(width: 220, height: 60)
                        .background(colors.background.opacity(0.3))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colors.primary, lineWidth: 3)
                    )
                }
                .padding(.bottom, 60)
                
                // Auto-dismiss countdown
                Text("Dismissing in \(countdown) seconds...")
                    .font(.system(size: 16))
                    .foregroundColor(colors.secondaryText.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            findWindow()
            startCountdown()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func timeString(from start: Date, to end: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    private func findWindow() {
        DispatchQueue.main.async {
            if let window = NSApp.windows.first(where: { $0.contentViewController is NSHostingController<ReminderView> }) {
                self.window = window
            }
        }
    }
    
    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                dismiss()
            }
        }
    }
    
    private func snooze() {
        timer?.invalidate()
        window?.close()
        
        // Schedule another reminder based on settings
        let snoozeSeconds = TimeInterval(settings.snoozeMinutes * 60)
        DispatchQueue.main.asyncAfter(deadline: .now() + snoozeSeconds) {
            let reminderView = ReminderView(event: event)
            let hostingController = NSHostingController(rootView: reminderView)
            
            let newWindow = NSWindow(contentViewController: hostingController)
            newWindow.styleMask = [.borderless, .fullSizeContentView]
            newWindow.level = .screenSaver
            newWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            newWindow.isOpaque = false
            newWindow.backgroundColor = .clear
            
            if let screen = NSScreen.main {
                newWindow.setFrame(screen.frame, display: true)
            }
            
            newWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    private func dismiss() {
        timer?.invalidate()
        window?.close()
    }
}


