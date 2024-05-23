
import WidgetKit
import SwiftUI

struct AnyWidgetEntryView: View {
    
    var entry: Provider.Entry
    
    var body: some View {
        if !entry.list.isEmpty {
            VStack(spacing: 0) {
                if entry.list.count == 1 {
                    OneDeviceView(devices: entry.list, color: entry.color1.color)
                } else if entry.list.count >= 2 {
                    TwoDeviceView(devices: entry.list, color1: entry.color1.color, color2: entry.color2.color)
                }
            }
        } else if entry.list.isEmpty {
            noDeviceView
                .padding(12)
        }
    }
}

extension AnyWidgetEntryView {
    
    // MARK: FUNCTIONS
    
    // MARK: PROPERTIES
    
    // no pinned view
    private var noDeviceView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Pinned devices not found")
                .foregroundStyle(.secondary)
            Text("Please pin any device in the app.")
                .foregroundStyle(.tertiary)
                .font(.caption)
            Spacer()
            Text("""
                *only first 2 pinned
                 devices are available.
                """)
            .foregroundStyle(.quaternary)
            .font(.caption2)
        }
    }
}
