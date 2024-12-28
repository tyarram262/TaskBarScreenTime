import SwiftUI

struct ContentView: View {
    var stats: [AppUsage] = [
        AppUsage(appName: "Safari", duration: 3600),
        AppUsage(appName: "Xcode", duration: 5400)
    ]

    var body: some View {
        VStack {
            Text("Screen Time Stats")
                .font(.headline)
                .padding()

            List(stats, id: \.appName) { usage in
                HStack {
                    Text(usage.appName)
                    Spacer()
                    Text("\(Int(usage.duration / 60)) minutes")
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
}
