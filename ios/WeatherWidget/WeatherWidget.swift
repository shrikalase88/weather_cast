import SwiftUI
import WidgetKit

private let widgetGroupId = "group.com.wc.weatherCast"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), temperature: "--°", city: "Weather Cast", description: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = WeatherEntry(
            date: Date(),
            temperature: data?.string(forKey: "temperature") ?? "--°",
            city: data?.string(forKey: "city_name") ?? "Weather Cast",
            description: data?.string(forKey: "description") ?? "..."
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        getSnapshot(in: context) { entry in
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
            completion(timeline)
        }
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let temperature: String
    let city: String
    let description: String
}

struct WeatherWidgetEntryView: View {
    var entry: WeatherEntry

    var body: some View {
        VStack(spacing: 4) {
            Text(entry.temperature)
                .font(.system(size: 36, weight: .light))
                .foregroundColor(Color(red: 0.9, green: 0.95, blue: 1.0))
            Text(entry.city)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.66, green: 0.7, blue: 0.82))
            Text(entry.description)
                .font(.system(size: 10))
                .foregroundColor(Color(red: 0.0, green: 0.82, blue: 0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.07, green: 0.1, blue: 0.16))
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Cast")
        .description("Current weather at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
