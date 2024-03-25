//
//  GoalPickerView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 11/03/24.
//

import SwiftUI

struct GoalPickerView: View {
    @Binding var selectedStepGoal: Int
    
    var body: some View {
        VStack {
            Picker(selection: $selectedStepGoal, label: Text("Step goal")) {
                Text("8000")
                    .tag(8000)
                Text("10000")
                    .tag(10000)
                Text("12000")
                    .tag(12000)
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.bottom)
            
            Text("Select the goal of steps to set the maximum health value of your creature.")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    GoalPickerView(selectedStepGoal: Binding.constant(8000))
}
