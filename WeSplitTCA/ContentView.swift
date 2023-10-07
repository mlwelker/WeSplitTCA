
import ComposableArchitecture
import SwiftUI

struct WeSplit { }

extension WeSplit: Reducer {
    var body: some ReducerOf<WeSplit> {
        Reduce { state, action in
            return .none
        }
    }
    
    enum Action: Equatable {
        
    }
    
    struct State: Equatable {
        var checkAmount = 0.0
        var numberOfPeople = 2
        var tipPercentage = 20
    }
}

struct ContentView: View {
    let store: StoreOf<WeSplit>
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        Form {
            Section {
//                TextField("Check Amount", text: )
            }
        }
    }
}

#Preview {
    ContentView(
        store: Store.init(
            initialState: WeSplit.State.init(),
            reducer: { WeSplit() }
        )
    )
}
