//
//  ContentView.swift
//  BetterRest
//
//  Created by Gert-Jan Vercauteren on 25/06/2020.
//  Copyright © 2020 Conneqtech. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var sleepTime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0 ) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return "Your ideal bedtime is: \(formatter.string(from: sleepTime))"
        } catch {
            return "Error calculating bedtime"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Picker(selection: $coffeeAmount, label: Text("Cups")) {
                        ForEach(1 ..< 21) {
                            if $0 == 1 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                }
                Text("\(sleepTime)")
                    .font(.headline)
                Spacer()
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
