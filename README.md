# GANetworkMonitor

GANetworkMonitor is a Swift package that allows you to monitor all URLs your app connects to, track how long each HTTP connection takes to complete, and detect whether an HTTP redirection occurred.

## Features

- Monitor network requests
- Track duration of HTTP connections
- Detect HTTP redirections

## Installation

### Using Swift Package Manager

1. Open your Xcode project.
2. Go to `File > Add Packages...`.
3. Enter the URL of this repository: `https://github.com/yourusername/GANetworkMonitor.git`.
4. Select `Add Package`.

### Using XCFramework

1. Download the `GANetworkMonitor.xcframework` from the `xcframework` directory.
2. Drag and drop the `GANetworkMonitor.xcframework` into your Xcode project.
3. Ensure the framework is added to the target's `Frameworks, Libraries, and Embedded Content` section.

## Usage:

### SwiftUI Project

1. **Import GANetworkMonitor**: Add the import statement in the files where you want to use the network monitor.

    ```swift
    import GANetworkMonitor
    ```

2. **Start Monitoring**: Initialize the network monitor in the app's entry point.

    ```swift
    import SwiftUI
    import GANetworkMonitor

    @main
    struct NetworkMonitorSwiftUIExampleApp: App {

        init() {
            // Start monitoring network requests
            GANetworkMonitor.startMonitoring()
        }

        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
    ```

3. **UI**: A simple view with a button to create network requests.

```
import SwiftUI
import GANetworkMonitor

struct ContentView: View {
    @State private var requestInfos: [GANetworkMonitor.RequestInfo] = []
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            Spacer()
            Button(action: {
                makeNetworkRequest()
            }) {
                Text("Make Network Request")
                    .padding()
            }.background(.green)
                .foregroundColor(.white)
                .padding()
        }
        .padding()
        .onAppear {
            // Fetch request info when the view appears
            makeNetworkRequest()
        }
        .background(.black)
    }
    
    private func makeNetworkRequest() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //Handling request through protocol
        }
        task.resume()
    }
}

#Preview {
    ContentView()
}
``` 
   
