//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Sergio on 05/08/22.
//

import WidgetKit
import SwiftUI
import Intents

// MARK: - Widget extension

@main
struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: AnimalSelectionIntent.self, provider: Provider(), content: { entry in
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
            WidgetExtensionEntryView(entry: SimpleEntry(
                animal: .unicorn,
                date: Date()
            ))
            PlaceholderView()
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

// MARK: - Widget view

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(spacing: 20) {
                Text(entry.animal.emoji)
                Text("\(entry.animal.age)")
            }
            .font(.body)
        case .systemMedium:
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    Text(entry.animal.emoji)
                    Text(entry.animal.name)
                }
                .frame(maxWidth: .infinity)
                .minimumScaleFactor(0.1)
                ZStack {
                    Circle()
                        .foregroundColor(.purple.opacity(0.3))
                        .frame(width: 120)
                    Text("\(entry.animal.age)")
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
        WidgetExtensionEntryView(entry: .init(
            animal: .unicorn,
            date: .now
        ))
        .redacted(reason: .placeholder)
    }
}

// MARK: - Timeline entry

struct SimpleEntry: TimelineEntry {
    let animal: AnimalDetail
    let date: Date
    let relevance: TimelineEntryRelevance?
    
    init(animal: AnimalDetail, date: Date) {
        self.animal = animal
        self.date = date
        self.relevance = .init(score: Float(animal.age))
    }
}

enum AnimalDetail {
    case ladybug
    case dinosaur
    case pufferFish
    case fish
    case unicorn
    case lobster
    
    var emoji: String {
        switch self {
        case .ladybug:
            return "🐞"
        case .dinosaur:
            return "🦕"
        case .pufferFish:
            return "🐡"
        case .fish:
            return "🐠"
        case .unicorn:
            return "🦄"
        case .lobster:
            return "🦞"
        }
    }

    var name: String {
        switch self {
        case .ladybug:
            return "Ladybug"
        case .dinosaur:
            return "Dinosaur"
        case .pufferFish:
            return "Puffer fish"
        case .fish:
            return "Cute fish"
        case .unicorn:
            return "Unicorn"
        case .lobster:
            return "Lobster"
        }
    }
    
    var age: Int {
        switch self {
        case .ladybug:
            return 1
        case .dinosaur:
            return 100
        case .pufferFish:
            return 2
        case .fish:
            return 3
        case .unicorn:
            return 999
        case .lobster:
            return 4
        }
    }
}

// MARK: - Timeline provider

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    func animal(for configuration: AnimalSelectionIntent) -> AnimalDetail {
        switch configuration.animal {
        case .unicorn:
            return .unicorn
        case .dinosaur:
            return .dinosaur
        case .fish:
            return .fish
        case .ladybug:
            return .ladybug
        case .lobster:
            return .lobster
        case .puffer:
            return .pufferFish
        case .unknown:
            fatalError("Unknown animal.")
        }
    }
    
    func getSnapshot(for configuration: AnimalSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(animal: .unicorn, date: .now)
        completion(entry)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(animal: .unicorn, date: .now)
    }
    
    func getTimeline(for configuration: AnimalSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(animal: animal(for: configuration), date: .now)], policy: .never)
        completion(timeline)
    }
}
