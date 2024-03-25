//
//  ExpressionWidgetExtension.swift
//  ExpressionWidgetExtension
//
//  Created by Alessandro on 05/03/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "FiTagotchi")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct ExpressionWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @State var healthPercentage: Double = UserDefaults(suiteName: "group.health123")!.double(forKey: "value")
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if healthPercentage > 0.4 {
                Image("happy_comp")
                    .resizable()
                    .frame(width: 50, height: 50)
            } else if healthPercentage > 0.2 {
                Image("sad_comp")
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                Image("comp_death")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
        .onAppear {
            healthPercentage = UserDefaults(suiteName: "group.health123")!.double(forKey: "value")
        }
        .onReceive(timer, perform: { _ in
            healthPercentage = UserDefaults(suiteName: "group.health123")!.double(forKey: "value")
        })
    }
}

@main
struct ExpressionWidgetExtension: Widget {
    let kind: String = "ExpressionWidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ExpressionWidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var happy: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.completionPercentage = 0.5
        return intent
    }
    
    fileprivate static var sad: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.completionPercentage = 0.1
        return intent
    }
    
    fileprivate static var death: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.completionPercentage = 0.0
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    ExpressionWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, configuration: .happy)
    SimpleEntry(date: .now, configuration: .sad)
    SimpleEntry(date: .now, configuration: .death)
}
