//
//  ContentView.swift
//  BetterRest
//
//  Created by Alonso Acosta Enriquez on 07/08/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertmessage = ""
    @State private var showAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var calculateBedtime: Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let dateComponents = Calendar.current.dateComponents(
                [.hour, .minute],
                from: wakeUp
            )
            let hour = (dateComponents.hour ?? 0) * 60 * 60
            let minute = (dateComponents.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeAmount)
            )
            
            return wakeUp - prediction.actualSleep
        } catch {
            return Date.now
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper(
                        "\(sleepAmount.formatted()) hours",
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25
                    )
                }
                
                Section("Daily coffee intake") {
                    Picker("^[\(coffeAmount) cup](inflect: true)", selection: $coffeAmount) {
                        ForEach(0...20, id: \.self) { cup in
                            Text("^[\(cup) cup](inflect: true)")
                        }
                    }
                }
                
                Section("Results") {
                    Text("Your ideal bedtime is... \(calculateBedtime.formatted(date: .omitted, time: .shortened))")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

#Preview {
    ContentView()
}
