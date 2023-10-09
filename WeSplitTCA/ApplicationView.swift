
import ComposableArchitecture
import SwiftUI

struct Application { 
}

extension Application: Reducer {
    struct State: Equatable {
        @BindingState var checkAmount = 0.0
        @BindingState var numberOfPeople = 2
        @BindingState var tipPercentage = 20
        var focused: Bool = false
//        @BindingState var amountIsFocused: Bool
        
        let currencyID = FloatingPointFormatStyle<Double>.Currency.currency(code: Locale.current.currency?.identifier ?? "USD")
        let tipPercentages = [10, 15, 20, 25, 0] // does this belong in State?
    }
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case checkAmountChanged(Double)
        case focusStateChanged(newValue: Bool)
        case doneButtonTapped
    }
    
    var body: some ReducerOf<Application> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding: return .none
            case .checkAmountChanged(let newAmount):
                state.checkAmount = newAmount
                return .none
            case .focusStateChanged(let newValue):
                state.focused = newValue
                return .none
            case .doneButtonTapped:
                state.focused = false
                return .none
            }
        }
    }
}

extension Application.State {
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount * (tipSelection / 100)
        let grandTotal = checkAmount + tipValue
        
        return grandTotal / peopleCount
    }
    
    var tipAmount: Double {
        return Double(tipPercentage) / 100 * checkAmount
    }
    
    var tipAmountString: String {
        return tipAmount.formatted(currencyID)
    }
    
    var billTotal: String {
        return checkAmount.formatted(currencyID)
    }
    
    var grandTotal: String {
        return (checkAmount + tipAmount).formatted(currencyID)
    }
}

struct ApplicationView: View {
    let store: StoreOf<Application>
    
    @FocusState private var focused: Bool
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    TextField("Amount", value: viewStore.$checkAmount, format: viewStore.currencyID)
                        .keyboardType(.decimalPad)
                        .focused($focused)
                    Picker("Number of people", selection: viewStore.$numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0)")
                        }
                    }
                } header: {
                    Text("bill total:")
                }
                Section {
                    VStack {
                        Picker("Tip percentage", selection: viewStore.$tipPercentage) {
                            ForEach(viewStore.tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                        Picker("custom tip", selection: viewStore.$tipPercentage) {
                            ForEach(0..<101) {
                                Text("\($0)%")
                            }
                        }
                    }
                } header: {
                    Text("Tip Amount:")
                }
                Section {
                    VStack {
                        Text("Bill: \(viewStore.billTotal)")
                        Text("+ Tip: \(viewStore.tipAmountString)")
                        Divider()
                        Text("Total: \(viewStore.grandTotal)")
                    }
                } header: {
                    Text("Summary:")
                }
                Section {
                    Text(viewStore.totalPerPerson, format: viewStore.currencyID)
                        .foregroundColor(viewStore.tipPercentage == 0 ? .red : .black)
                } header: {
                    Text("each person owes:")
                }
            }
            .navigationTitle("WeSplit") // SwiftUI preference, preference keys
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        viewStore.send(.doneButtonTapped)
                    }
                }
            }
            .onChange(of: viewStore.focused) { old, new in
                focused = new
            }
            .onChange(of: focused) { old, new in
                viewStore.send(.focusStateChanged(newValue: new))
            }
        }
    }
}

#Preview {
    ApplicationView(
        store: Store.init(
            initialState: Application.State.init(),
            reducer: { Application() }
        )
    )
}
