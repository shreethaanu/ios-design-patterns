import UIKit
import Foundation
import EventKit

// our target protocol
protocol Event {
    var title: String { get }
    var startDate: String { get }
    var endDate: String { get }
}

// adapter (wrapper class)
class EventAdapter {

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm"
        return dateFormatter
    }()

    private var event: EKEvent

    init(event: EKEvent) {
        self.event = event
    }
}

// actual adapter implementation
extension EventAdapter: Event {

    var title: String {
        return self.event.title
    }
    var startDate: String {
        return self.dateFormatter.string(from: event.startDate)
    }
    var endDate: String {
        return self.dateFormatter.string(from: event.endDate)
    }
}

// let's create an EKEvent adaptee instance
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"

let calendarEvent = EKEvent(eventStore: EKEventStore())
calendarEvent.title = "Adapter tutorial deadline"
calendarEvent.startDate = dateFormatter.date(from: "07/30/2018 10:00")
calendarEvent.endDate = dateFormatter.date(from: "07/30/2018 11:00")

// now we can use the adapter class as an Event protocol, instead of an EKEvent
let adapter = EventAdapter(event: calendarEvent)
// adapter.title
// adapter.startDate
// adapter.endDate
