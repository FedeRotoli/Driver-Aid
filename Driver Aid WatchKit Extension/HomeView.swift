//
//  HomeView.swift
//  Driver Aid WatchKit Extension
//
//  Created by Federico Rotoli on 14/01/2020.
//  Copyright © 2020 Federico Rotoli. All rights reserved.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @State private var showingSettings = false
    @State private var activeSecurity = false
    private var healthStore = HKHealthStore()
    private var timer: Timer?
    @State private var value = 0
    
    var body: some View {
        VStack{
            ZStack{
                Group{
                    Circle()
                        .foregroundColor(activeSecurity ? Color.init(red: 0, green: 135/256, blue: 0):Color.init(red: 0.2, green: 0.2, blue: 0.2).opacity(0.8))
                        .animation(.easeInOut(duration: 0.5), value: activeSecurity)
                        .frame(width: 64, height: 64)
                        
                    Image(activeSecurity ? "shieldON":"shieldOFF")
                }
            }.onTapGesture {
                self.activeSecurity.toggle()
                if self.activeSecurity{
                    self.autorizeHealthKit()
                    self.saveMockHeartData()
                }
            }

            Text("Safety")
            Text("BPM:  \(value)")
        }.multilineTextAlignment(.center)
    }

    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }

    }
    
    func saveMockHeartData() {

      // 1. Create a heart rate BPM Sample
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let heartRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"),
        doubleValue: Double(arc4random_uniform(80) + 100))
      let heartSample = HKQuantitySample(type: heartRateType,
                                         quantity: heartRateQuantity, start: NSDate() as Date, end: NSDate() as Date)

      // 2. Save the sample in the store
        healthStore.save(heartSample, withCompletion: { (success, error) -> Void in
        if let error = error {
          print("Error saving heart sample: \(error.localizedDescription)")
        }
      })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


