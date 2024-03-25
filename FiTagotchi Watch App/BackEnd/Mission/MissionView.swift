//
//  MissionView.swift
//  FiTagotchi Watch App
//
//  Created by Davide Perrotta on 01/03/24.
//

import SwiftUI

public struct MissionView: View {
    @StateObject var health: HealthManager
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    @State private var goalselection: GoalPickerView?
    
    var goals: [Goal] {
        [
            Goal(title: "Daily Access", icon: "star.circle.fill", goalType: .dailyReward, coins: 2, goal: 1, coinsEarned: 2),
            Goal(title: "Step Goal: \(fiTagotchiData.stepGoal)", icon: "star.circle.fill", goalType: .stepCount, coins: 3, goal: fiTagotchiData.stepGoal, coinsEarned: 3),
            Goal(title: "Stairs: 10", icon: "star.circle.fill", goalType: .flightsClimbed, coins: 3, goal: 10, coinsEarned: 3),
            Goal(title: "Calories: 350", icon: "star.circle.fill", goalType: .activeEnergyBurned, coins: 3, goal: 350, coinsEarned: 3),
            Goal(title: "Stand Minutes: 65", icon: "star.circle.fill", goalType: .standMinutes, coins: 3, goal: 65, coinsEarned: 3),
            Goal(title: "Heart Rate: 60", icon: "star.circle.fill", goalType: .restingHeartRate, coins: 2, goal: 60, coinsEarned: 2),
            Goal(title: "Distance Walked: 5km", icon: "star.circle.fill", goalType: .distanceWalkingRunning, coins: 6, goal: 5, coinsEarned: 6),
            ]
        }


    public var body: some View {
        List {
            ForEach(goals.indices, id: \.self) { index in
                let goal = goals[index]
                
                MissionGoalView(goal: goal, health: health)
                    .id("(goal.title)-(index)")
            }
            
            Text("Missions reset every day.")
                .font(.footnote)
                .listRowBackground(Color.clear)
                .foregroundStyle(.gray)
            
            Text("When you complete a challenge, coins will be automatically added to your balance in the 'Food' section.")
                .font(.footnote)
                .listRowBackground(Color.clear)
                .foregroundStyle(.gray)
        }
        .navigationBarTitle("Missions")
        .onAppear() {
            resetGoalKeys()
        }
    }
    
    func resetGoalKeys() {
        let currentDate = Date()
        
        // Verifica se esiste una data di ultimo reset nelle UserDefaults
        if let lastResetDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastResetDate) as? Date {
            // Verifica se la data corrente è in un giorno diverso dalla data di ultimo reset
            if !Calendar.current.isDate(currentDate, inSameDayAs: lastResetDate) {
                // Resetta tutti i valori di goalKey a false
                for goal in goals {
                    let goalKey = "\(goal.title)-\(goal.goalType)"
                    UserDefaults.standard.set(false, forKey: goalKey)
                }
                
                // Aggiorna la data di ultimo reset
                UserDefaults.standard.setValue(currentDate, forKey: UserDefaultsKeys.lastResetDate)
                
                print("Valori dei goalKey resettati a false.")
            }
        } else {
            print("Primo accesso: valori dei goalKey a false.")
            // Se non esiste una data di ultimo reset, imposta la data corrente come data di ultimo reset
            UserDefaults.standard.setValue(currentDate, forKey: UserDefaultsKeys.lastResetDate)
        }
    }
    
}
