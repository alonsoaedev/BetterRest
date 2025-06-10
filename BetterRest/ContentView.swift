//
//  ContentView.swift
//  BetterRest
//
//  Created by Alonso Acosta Enriquez on 07/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    func calculateBedtime() {
        // todo
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker(
                    "Please enter a time",
                    selection: $wakeUp,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(
                    "\(sleepAmount.formatted()) hours",
                    value: $sleepAmount,
                    in: 4...12,
                    step: 0.25
                )
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(
                    "\(coffeAmount) cup(s)",
                    value: $coffeAmount,
                    in: 0...20
                )
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
}

#Preview {
    ContentView()
}
