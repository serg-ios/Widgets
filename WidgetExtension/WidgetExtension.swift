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
        let entry = SimpleEntry(emoji: "🐙", name: "Octopus", age: 0, date: .now)
        completion(entry)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(emoji: "⏳", name: "Placeholder", age: -1, date: .now)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var dates: [Date] = [Date.now]
        for hourOffset in 1 ..< 6 {
            if let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: dates[hourOffset - 1]) {
                dates.append(entryDate)
            }
        }
        let timeline = Timeline(entries: [
            SimpleEntry(emoji: "🐞", name: "Ladybug", age: 1, date: dates[0]),
            SimpleEntry(emoji: "🐠", name: "Cute fish", age: 2, date: dates[1]),
            SimpleEntry(emoji: "🦕", name: "Dinosaur", age: 100, date: dates[2]),
            SimpleEntry(emoji: "🐡", name: "Puffer fish", age: 3, date: dates[3]),
            SimpleEntry(emoji: "🦞", name: "Lobster", age: 4, date: dates[4]),
            SimpleEntry(emoji: "🦄", name: "Unicorn", age: 999, date: dates[5]),
        ], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let emoji: String
    let name: String
    let age: Int
    let date: Date
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(spacing: 20) {
                Text(entry.emoji)
                Text("\(entry.age)")
            }
            .font(.body)
        case .systemMedium:
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    Text(entry.emoji)
                    Text(entry.name)
                }
                .frame(maxWidth: .infinity)
                .minimumScaleFactor(0.1)
                ZStack {
                    Circle()
                        .foregroundColor(.purple.opacity(0.3))
                        .frame(width: 120)
                    Text("\(entry.age)")
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.largeTitle)
            .padding(20)
        default:
            fatalError("Not implemented yet.")
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        WidgetExtensionEntryView(entry: .init(emoji: "⏳", name: "Placeholder", age: -1, date: .now))
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
            WidgetExtensionEntryView(entry: SimpleEntry(emoji: "🐨", name: "Koala", age: 999, date: Date()))
            PlaceholderView()
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
