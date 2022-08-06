//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Sergio on 05/08/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(emoji: "🐙", name: "Octopus", date: .now)
        completion(entry)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(emoji: "⏳", name: "Placeholder", date: .now)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var dates: [Date] = [Date.now]
        for hourOffset in 1 ..< 6 {
            if let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: dates[hourOffset - 1]) {
                dates.append(entryDate)
            }
        }
        let timeline = Timeline(entries: [
            SimpleEntry(emoji: "🐞", name: "Ladybug", date: dates[0]),
            SimpleEntry(emoji: "🐠", name: "Cute fish", date: dates[1]),
            SimpleEntry(emoji: "🦕", name: "Dinosaur", date: dates[2]),
            SimpleEntry(emoji: "🐡", name: "Puffer fish", date: dates[3]),
            SimpleEntry(emoji: "🦞", name: "Lobster", date: dates[4]),
            SimpleEntry(emoji: "🦄", name: "Unicorn", date: dates[5]),
        ], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let emoji: String
    let name: String
    let date: Date
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            Text(entry.emoji)
                .font(.body)
        case .systemMedium:
            VStack {
                Text(entry.emoji)
                Text(entry.name)
            }
            .font(.largeTitle)
        default:
            fatalError("Not implemented yet.")
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        WidgetExtensionEntryView(entry: .init(emoji: "⏳", name: "Placeholder", date: .now))
            .redacted(reason: .placeholder)
    }
}

@main
struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: { entry in
            WidgetExtensionEntryView(entry: entry)
        })
        .configurationDisplayName("Name of the widget")
        .description("Description of the widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetExtensionEntryView(entry: SimpleEntry(emoji: "🐨", name: "Koala", date: Date()))
            PlaceholderView()
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
