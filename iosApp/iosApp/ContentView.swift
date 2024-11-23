import SwiftUI
import Shared

struct ContentView: View {
    @State private var newMeal: String = ""
    @State private var isKeyboardVisible = false
    @FocusState private var isTextFieldFocused: Bool
    
    @State var viewModel = MenuViewModel()
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationSplitView {
                VStack {
                    Observing (viewModel.menuViewModelState) {state in
                        
                        List {
                            Observing (viewModel.menuViewModelState) {state in
                                ForEach(state.meals, id: \.heading) { meal in
                                    CalorieItem(title: meal.heading, subtitle: meal.description_ + " - \(meal.calories) Calories")
                                }
                            }
                        }.navigationTitle("Total calories: " + String(viewModel.getTotalCalories()))
                    }
                }.onTapGesture {
                    self.endTextEditing()
                    print("Tap gesture: " + isKeyboardVisible.description)
                    // If keyboard is visible
                    if isKeyboardVisible {
                        isKeyboardVisible = false
                        isTextFieldFocused = false
                    }
                }
                
                if isKeyboardVisible {
                    VStack {
                        TextField("Enter text", text: $newMeal)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border
                            .background(Color.clear) // Clear background for the text field
                            .cornerRadius(8) // Optional: rounded corners
                            .focused($isTextFieldFocused) // Bind focus state to the TextField
                            .submitLabel(.done)
                            .onAppear {
                                // Automatically focus the TextField when it appears
                                isTextFieldFocused = true
                            }
                            .onSubmit {
                                viewModel.processUserIntents(userIntent: MenuIntent.AddMeal(desc: newMeal))
                                newMeal = ""
                                
                                isTextFieldFocused = false
                                isKeyboardVisible = false 
                            }
                    }
                } else {
                    Button(action: {
                        isKeyboardVisible = true
                    }) {
                        Text("New Meal")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 10)
                }
                
                
            } detail: {
                Text("Select a Landmark")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
