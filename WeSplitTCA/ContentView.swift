
import ComposableArchitecture
import SwiftUI

struct WeSplit { }

extension WeSplit: Reducer {
    var body: some ReducerOf<WeSplit> {
        Reduce { state, action in
            switch action {
            case .checkAmountChanged(let newAmount):
                state.checkAmount = newAmount
                return .none
            }
        }
    }
    
    enum Action: Equatable {
        case checkAmountChanged(Double)
    }
    
    struct State: Equatable {
        var checkAmount = 0.0
        var numberOfPeople = 2
        var tipPercentage = 20
        
        let tipPercentages = [10, 15, 20, 25, 0] // does this belong in State?
    }
}

struct ContentView: View {
    let store: StoreOf<WeSplit>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    TextField(
                        "Check Amount",
                        value: viewStore.binding(
                            get: \.checkAmount,
                            send: { .checkAmountChanged($0) }),
                        format: .currency(code: "USD")
                    )
                }
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
