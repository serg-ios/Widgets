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
        let entry = SimpleEntry(emoji: "🐙", date: .now)
        completion(entry)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(emoji: "placeholder", date: .now)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var dates: [Date] = [Date.now]
        for hourOffset in 1 ..< 6 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: dates.last!)!
            dates.append(entryDate)
        }
        let timeline = Timeline(entries: [
            SimpleEntry(emoji: "🐞", date: dates[0]),
            SimpleEntry(emoji: "🐠", date: dates[1]),
            SimpleEntry(emoji: "🦕", date: dates[2]),
            SimpleEntry(emoji: "🐡", date: dates[3]),
            SimpleEntry(emoji: "🦞", date: dates[4]),
            SimpleEntry(emoji: "🦄", date: dates[5]),
        ], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let emoji: String
    let date: Date
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.emoji)
    }
}

struct PlaceholderView: View {
    var body: some View {
        Text("placeholder")
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
        .supportedFamilies([.systemSmall])
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetExtensionEntryView(entry: SimpleEntry(emoji: "🐨", date: Date()))
            PlaceholderView()
        }
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
