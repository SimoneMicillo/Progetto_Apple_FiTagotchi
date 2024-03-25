//
//  SettingsView.swift
//  viewsettingprova Watch App
//
//  Created by Giancarlo Canestro on 19/02/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    @State private var currentDifficult: Difficulty = .normal
    @State private var currentStartTime: Date = FiTagotchiData.defaultStartTime
    @State private var currentEndTime: Date = FiTagotchiData.defaultEndTime
    @State private var currentStepGoal: Int = 8000

    var body: some View {
        List {
            Section(content: {
                timePickerSection(title: "Bedtime", binding: $fiTagotchiData.startTime)
            }, header: {
                Text("Bedtime")
            }, footer: {
                Text("Set the time your creature will go to sleep.")
            })

            Section(content: {
                timePickerSection(title: "Wake up time", binding: $fiTagotchiData.endTime)
            }, header: {
                Text("Wake up time")
            }, footer: {
                Text("Set the time your creature will wake up.")
            })
            
            Section(content: {
                goalStepSection(binding: $fiTagotchiData.stepGoal)
            }, header: {
                Text("Step Goal")
            }, footer: {
                Text("Set your goal of steps to synchronize the creature’s health.")
            })
            
            Section(content: {
                difficultySection(binding: fiTagotchiData)
            }, header: {
                Text("Difficulty")
            }, footer: {
                Text("Select the game difficulty level.")
            })

            // Weelchair mode disabilitata (future implementations)
//            Section(content: {
//                VStack(alignment: .leading) {
//                    Toggle(isOn: $fiTagotchiData.wheelchairModeEnabled) {
//                        Text("Enable")
//                    }
//                }
//            }, header: {
//                Text("Wheelchair Mode")
//            }, footer: {
//                Text("Enable the mode for users with a wheelchair for an optimized gaming experience.")
//            })
            
            Section(content: {
                VStack(alignment: .leading) {
                    Toggle(isOn: $fiTagotchiData.hapticFeedbackEnabled) {
                        Text("Enable")
                    }
                }
            }, header: {
                Text("Haptic Feedback")
            }, footer: {
                Text("Enable haptic feedback during interaction with your creature and other objects.")
            })
        }
        .navigationBarTitle("Settings")
        .onAppear {
            // Inizializza currentStartTime da UserDefaults all'apertura della vista
            if let savedStartTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.startTime) as? Date {
                currentStartTime = savedStartTime
            }
            
            // Inizializza currentEndTime da UserDefaults all'apertura della vista
            if let savedEndTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.endTime) as? Date {
                currentEndTime = savedEndTime
            }
            
            // Inizializza currentDifficult da UserDefaults all'apertura della vista
            if let savedDifficulty = UserDefaults.standard.string(forKey: UserDefaultsKeys.difficulty), let difficulty = Difficulty(rawValue: savedDifficulty) {
                    currentDifficult = difficulty
                }
            
            // Inizializza currentStepGoal da UserDefaults all'apertura della vista
            let savedStepGoal = UserDefaults.standard.integer(forKey: UserDefaultsKeys.stepGoal)
            if savedStepGoal != 0 {
                currentStepGoal = savedStepGoal
            }
        }
    }

    @ViewBuilder
    private func timePickerSection(title: String, binding: Binding<Date>) -> some View {
        NavigationLink(destination: DatePickerView(selectedDate: binding, title: title)) {
            HStack {
                Text("Current time:")
                Spacer()
                Text("\(formattedTime(from: title == "Bedtime" ? currentStartTime : currentEndTime))")
            }
        }
    }
    
    @ViewBuilder
    private func difficultySection(binding: FiTagotchiData) -> some View {
        NavigationLink(destination: DifficultySelectionView(fiTagotchiData: binding)) {
            HStack {
                Text("Current:")
                Spacer()
                Text("\(currentDifficult.rawValue)")
            }
        }
    }
    
    @ViewBuilder
    private func goalStepSection(binding: Binding<Int>) -> some View {
        NavigationLink(destination: GoalPickerView(selectedStepGoal: binding)) {
            HStack {
                Text("Current:")
                Spacer()
                Text("\(currentStepGoal)")
            }
        }
    }

    private func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
