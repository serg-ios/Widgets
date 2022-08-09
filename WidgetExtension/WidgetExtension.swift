//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Sergio on 05/08/22.
//

import WidgetKit
import SwiftUI
import Intents

// MARK: - Widget bundle

@main
struct AnimalsWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WidgetExtension()
        LargeWidgetExtension()
        CitiesWidgetExtension()
    }
}

// MARK: - Widget extension

struct CitiesWidgetExtension: Widget {
    let kind: String = "CitiesWidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CitiesProvider(), content: { entry in
            CitiesWidgetExtensionEntryView(city: entry.city)
        })
        .configurationDisplayName("Cities' widget")
        .description("Displays the weather in a city.")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct LargeWidgetExtension: Widget {
    let kind: String = "LargeWidgetExtension"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: AnimalSelectionIntent.self, provider: Provider(), content: { entry in
            LargeWidgetExtensionEntryView()
        })
        .configurationDisplayName("Large widget")
        .description("Shows many animals.")
        .supportedFamilies([.systemLarge])
    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: AnimalSelectionIntent.self, provider: Provider(), content: { entry in
            WidgetExtensionEntryView(entry: entry)
        })
        .configurationDisplayName("Name of the widget")
        .description("Description of the widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaceholderView()
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            WidgetExtensionEntryView(entry: .init(animal: .unicorn, date: .now))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            LargeWidgetExtensionEntryView()
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            LargePlaceholderView()
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            WidgetExtensionEntryView(entry: .init(animal: .unicorn, date: .now))
                .previewContext(WidgetPreviewContext(family: .accessoryInline))
                .previewDisplayName("Inline")
            WidgetExtensionEntryView(entry: .init(animal: .dinosaur, date: .now))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                .previewDisplayName("Circular")
            WidgetExtensionEntryView(entry: .init(animal: .unicorn, date: .now))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("Rectangular")
        }
    }
}

// MARK: - Cities' widget view

struct CitiesWidgetExtensionEntryView: View {
    let city: City
    var body: some View {
        Text(city.name)
    }
}

// MARK: - Large widget view

struct LargeWidgetExtensionEntryView: View {
    var body: some View {
        VStack {
            ForEach(AnimalDetail.allCases) { animal in
                Link(destination: animal.url) {
                    HStack {
                        Text(animal.emoji)
                        Text(animal.name)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 40)
            .font(.largeTitle)
        }
    }
}

struct LargePlaceholderView: View {
    var body: some View {
        LargeWidgetExtensionEntryView()
            .redacted(reason: .placeholder)
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
            .widgetURL(entry.animal.url)
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
            .widgetURL(entry.animal.url)
        case .accessoryInline:
            ViewThatFits {
                Text("\(entry.animal.emoji) is called \(entry.animal.name) and is \(entry.animal.age)")
                Text("\(entry.animal.emoji) \(entry.animal.name) \(entry.animal.age)")
            }
        case .accessoryCircular:
            ZStack {
                ProgressView(value: Float(entry.animal.age), total: Float(AnimalDetail.unicorn.age))
                    .progressViewStyle(.circular)
                Text(entry.animal.emoji)
                    .font(.largeTitle)
            }
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                Text(entry.animal.name)
                    .font(.headline)
                    .widgetAccentable()
                Text("\(entry.animal.age)")
                    .privacySensitive()
                Text(entry.animal.emoji)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        default:
            Text("Widget family supported.")
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

struct CityEntry: TimelineEntry {
    let city: City
    let date: Date
}

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

// MARK: - Timeline provider

struct CitiesProvider: TimelineProvider {
    typealias Entry = CityEntry
    
    func placeholder(in context: Context) -> CityEntry {
        .init(city: .init(name: "Roma", temperature: "33°C", precipitation: "23 %"), date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CityEntry) -> Void) {
        completion(.init(city: .init(name: "Roma", temperature: "33°C", precipitation: "23 %"), date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CityEntry>) -> Void) {
        let path = Bundle.main.url(forResource: "cities", withExtension: "json")!
        var request = URLRequest(url: path)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, _, _ in
            let cities = try! JSONDecoder().decode(Cities.self, from: data!)
            completion(.init(entries: {
                cities.enumerated().map {
                    .init(city: $0.element, date: .now.addingTimeInterval(5 * TimeInterval($0.offset)))
                }
            }(), policy: .atEnd))
        }.resume()
    }
}

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
