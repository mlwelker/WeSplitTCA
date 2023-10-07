
import ComposableArchitecture
import SwiftUI

@main
struct WeSplitTCAApp: App {
    let store = Store(initialState: WeSplit.State.init()) {
        WeSplit()._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
