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
    
    func calculateBedtime() {
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
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertmessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Eror"
            alertmessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showAlert = true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                
                VStack(alignment: .leading) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(
                        "\(sleepAmount.formatted()) hours",
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(
                        "^[\(coffeAmount) cup](inflect: true)",
                        value: $coffeAmount,
                        in: 0...20
                    )
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {  }
            } message: {
                Text(alertmessage)
            }
        }
    }
}

#Preview {
    ContentView()
}
