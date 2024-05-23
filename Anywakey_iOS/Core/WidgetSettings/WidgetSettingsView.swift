
import SwiftUI
import WidgetKit

struct WidgetSettingsView: View {
    
    @AppStorage("widgetColor_1") var widgetColorIndex_1: Int = 0
    @AppStorage("widgetColor_2") var widgetColorIndex_2: Int = 1
    @Environment(\.colorScheme) var colorScheme
    
    @State var tileEditingNumber: Int = 3
    
    let devicesAmount: Int
    
    let colors = [
        Color.widget.green,
        Color.widget.blue,
        Color.widget.orange,
        Color.widget.pink,
        Color.widget.purpule,
        Color.widget.yellow
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: devicesAmount > 1 ? 9 : 0) {
                    Tile(colors: colors[widgetColorIndex_1], height: .infinity)
                        .opacity(
                            tileEditingNumber == 1 ? 1.0 :
                                tileEditingNumber == 3 ? 1 : 0.4)
                        .onTapGesture {
                            withAnimation(.smooth) {
                                tileEditingNumber = 1
                            }
                        }
                    Tile(colors: colors[widgetColorIndex_2], height: devicesAmount > 1 ? .infinity : 0)
                        .opacity(
                            tileEditingNumber == 2 ? 1.0 :
                                tileEditingNumber == 3 ? 1 : 0.4)
                        .onTapGesture {
                            withAnimation(.smooth) {
                                tileEditingNumber = 2
                            }
                        }
                }
                .padding(9)
                .frame(width: 200, height: 200)
                .background {
                    tileBackground
                }
                
                HStack {
                    Text("Colors")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal)
                VStack(spacing: 0) {
                    ForEach(colors) { color in
                        Button {
                            withAnimation(.smooth) {
                                if tileEditingNumber == 1 {
                                    widgetColorIndex_1 = getIndex(color: color)
                                } else if tileEditingNumber == 2 {
                                    widgetColorIndex_2 = getIndex(color: color)
                                }
                            }
                        } label: {
                            HStack {
                                Text(color.description)
                                    .foregroundStyle(LinearGradient(colors: color.color, startPoint: .topLeading, endPoint: .bottomTrailing))
                                Spacer()
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(colors: color.color, startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 35, height: 35)
                                
                            }
                            
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.horizontal, 16)
                            .background(colorScheme == .dark ? .gray.opacity(0.1) : .white)
                        }
                        .frame(height: 45)
                        .buttonStyle(.plain)
                        Divider().opacity(colors.last?.id == color.id ? 0 : 1.0)
                    }
                }
                .background(colorScheme == .light ? .white : Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .navigationTitle("Widget settings")
            }
            .padding()
        }
        .background {
            if colorScheme == .light {
                Color.gray.opacity(0.1).ignoresSafeArea()
            }
        }
        .onTapGesture {
            withAnimation(.smooth) {
                tileEditingNumber = 3
            }
        }
        .onChange(of: widgetColorIndex_1) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: widgetColorIndex_2) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

extension WidgetSettingsView {
    
    // MARK: PROPERTIES
    
    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill()
            .foregroundStyle(.gray.opacity(0.2))
            .frame(width: 200, height: 200)
    }
    
    
    // MARK: FUNCTIONS
    func getIndex(color: GradientColor) -> Int {
        for index in 0..<colors.count {
            if color.id == colors[index].id{
                return index
            }
        }
        return 0
    }
    
    func saveIndecies() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            userDefaults.setValue(widgetColorIndex_1, forKey: "widgetColor_1")
            userDefaults.setValue(widgetColorIndex_2, forKey: "widgetColor_2")
        }
    }
    
    func fetchColors() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            widgetColorIndex_1 = userDefaults.integer(forKey: "widgetColor_1")
            widgetColorIndex_2 = userDefaults.integer(forKey: "widgetColor_2")
        }
    }
    
}

//#Preview {
//    WidgetSettingsView(devicesAmount: 2)
//}
