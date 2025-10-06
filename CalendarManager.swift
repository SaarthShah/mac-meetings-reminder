import EventKit
import Foundation

class CalendarManager: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var hasAccess = false
    
    func requestAccess() async -> Bool {
        do {
            if #available(macOS 14.0, *) {
                let granted = try await eventStore.requestFullAccessToEvents()
                await MainActor.run {
                    self.hasAccess = granted
                }
                return granted
            } else {
                return await withCheckedContinuation { continuation in
                    eventStore.requestAccess(to: .event) { granted, error in
                        Task { @MainActor in
                            self.hasAccess = granted
                        }
                        continuation.resume(returning: granted)
                    }
                }
            }
        } catch {
            print("Calendar access error: \(error)")
            await MainActor.run {
                self.hasAccess = false
            }
            return false
        }
    }
    
    func getUpcomingEvents(within minutes: Int) -> [EKEvent] {
        guard hasAccess else { return [] }
        
        let now = Date()
        let future = Calendar.current.date(byAdding: .minute, value: minutes, to: now)!
        
        let predicate = eventStore.predicateForEvents(withStart: now, end: future, calendars: nil)
        let events = eventStore.events(matching: predicate)
        
        return events.filter { event in
            !event.isAllDay && event.startDate > now
        }
    }
    
    func getEventsStartingNow(minutesBefore: Int = 1) -> [EKEvent] {
        guard hasAccess else { return [] }
        
        let now = Date()
        let minutesAgo = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: now)!
        let oneMinuteLater = Calendar.current.date(byAdding: .minute, value: 1, to: now)!
        
        let predicate = eventStore.predicateForEvents(withStart: minutesAgo, end: oneMinuteLater, calendars: nil)
        let events = eventStore.events(matching: predicate)
        
        return events.filter { event in
            !event.isAllDay &&
            event.startDate <= now &&
            event.endDate > now
        }
    }
}


