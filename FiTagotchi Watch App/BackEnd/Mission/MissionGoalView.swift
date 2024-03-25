//
//  MissionGoalView.swift
//  FiTagotchi Watch App
//
//  Created by Davide Perrotta on 09/03/24.
//
import SwiftUI

struct MissionGoalView: View {
    var goal: Goal
    
    @ObservedObject var health: HealthManager
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    
    @State private var stepCount: Int = 0
    @State private var flightsClimbed: Int = 0
    @State private var burnedCalories: Int = 0
    @State private var minutesExercise: Int = 0
    @State private var restingHeartRate: Int = 0
    @State private var distanceWalkingRunning: Int = 0
    
    public var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(goal.title)
                        .bold()
                        .padding(.bottom, 2)
                }
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    switch goal.goalType {
                    case .dailyReward:
                        Text("Log in for today.")
                            .font(.footnote)
                    case .stepCount:
                        Text("Current: \(stepCount)")
                            .font(.footnote)
                    case .flightsClimbed:
                        Text("Current: \(flightsClimbed)")
                            .font(.footnote)
                    case .activeEnergyBurned:
                        Text("Current: \(burnedCalories)")
                            .font(.footnote)
                    case .standMinutes:
                        Text("Minutes: \(minutesExercise)")
                            .font(.footnote)
                    case .restingHeartRate:
                        Text("Current: \(restingHeartRate)")
                            .font(.footnote)
                    case .distanceWalkingRunning:
                        Text("Current km: \(distanceWalkingRunning)")
                            .font(.footnote)
                    }
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: goal.icon)
                        .foregroundColor(.yellow)
                    Text("\(goal.coins)")
                        .bold()
                        .padding(.trailing, 2)
                }
                .padding(.all, 3)
                .background(.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            VStack(alignment: .center) {
                if goalReached() {
                    Text("Goal reached! You earned a reward!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.green)
                        .padding(.top, 4)
                }
            }
        }
        .padding()
        .onAppear {
            // Chiamata alle funzioni appropriate per ottenere i dati necessari
            switch goal.goalType {
            case .dailyReward:
                self.fetchDailyReward()
            case .stepCount:
                self.fetchStepCount()
            case .flightsClimbed:
                self.fetchFlightsClimbed()
            case .activeEnergyBurned:
                self.fetchActiveEnergyBurned()
            case .standMinutes:
                self.fetchStandMinutes()
            case .restingHeartRate:
                self.fetchRestingHeartRate()
            case .distanceWalkingRunning:
                self.fetchDistanceWalkingRunning()
            }
            
            checkGoalKeyValue()
        }
    }
    
    func fetchDailyReward() {
        let currentDate = Date()
        print("Daily access: \(fiTagotchiData.dailyAccess)")
        // Recuperiamo la data dell'ultimo accesso memorizzata nelle UserDefaults
        if let lastAccessDate = UserDefaults.standard.object(forKey: "latestInactiveTimeDayLogin") as? Date {
            // Se la data di oggi è diversa dalla data dell'ultimo accesso, porta il valore ad 1
            if !Calendar.current.isDate(currentDate, inSameDayAs: lastAccessDate)
            {
                fiTagotchiData.dailyAccess = 1
                UserDefaults.standard.setValue(currentDate, forKey: "latestInactiveTimeDayLogin")
            }
        }
        else
        {
            print("Not found: lastAccessDate")
            fiTagotchiData.dailyAccess = 1
            UserDefaults.standard.setValue(currentDate, forKey: "latestInactiveTimeDayLogin")
        }
    }
    
    
    func fetchStepCount() {
        health.getStepCount { stepCount in
            self.stepCount = stepCount
        }
    }
    
    func fetchFlightsClimbed() {
        health.retrieveFlightsClimbed { flightsClimbed in
            self.flightsClimbed = flightsClimbed
        }
    }
    
    func fetchActiveEnergyBurned() {
        health.readTodaysActiveEnergyBurned { burnedCalories in
            self.burnedCalories = burnedCalories
        }
    }
    
    func fetchStandMinutes() {
        health.retrieveStandMinutes { minutesExercise in
            self.minutesExercise = minutesExercise
        }
    }
    
    func fetchRestingHeartRate() {
        health.fetchRestingHeartRateData { heartRate in
            if let heartRate = heartRate {
                self.restingHeartRate = heartRate
            } else {
                print("Il valore della frequenza cardiaca a riposo non è disponibile.")
            }
        }
    }
    
    func fetchDistanceWalkingRunning() {
        health.DistanceWalkingRunning { distance in
            self.distanceWalkingRunning = distance
        }
    }
    
    func goalReached() -> Bool {
        // Implementa la logica per determinare se l'obiettivo è stato raggiunto
        switch goal.goalType {
        case .dailyReward:
            if fiTagotchiData.dailyAccess == goal.goal {
                return true
            }
        case .stepCount:
            if stepCount >= goal.goal {
                return true
            }
        case .flightsClimbed:
            if flightsClimbed >= goal.goal {
                return true
            }
        case .activeEnergyBurned:
            if burnedCalories >= goal.goal {
                return true
            }
        case .standMinutes:
            if minutesExercise >= goal.goal {
                return true
            }
        case .restingHeartRate:
            if restingHeartRate >= goal.goal {
                return true
            }
        case .distanceWalkingRunning:
            if distanceWalkingRunning >= goal.goal {
                return true
            }
        }
        return false
    }

    func checkGoalKeyValue() {
        if goalReached() {
            let goalKey = "\(goal.title)-\(goal.goalType)"
            print("Key: \(UserDefaults.standard.bool(forKey: goalKey))")
            if !UserDefaults.standard.bool(forKey: goalKey) {
                fiTagotchiData.actualCoins += goal.coinsEarned
                UserDefaults.standard.set(true, forKey: goalKey)
            }
        }
    }
    
}

