
import ComposableArchitecture
import SwiftUI

@main
struct WeSplitTCAApp: App {
    let store = Store(initialState: Application.State.init()) {
        Application()._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            ApplicationView(store: store)
        }
    }
}
