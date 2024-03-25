//
//  StatisticCircleView.swift
//  FiTagotchi Watch App
//
//  Created by Davide Dolce on 15/02/24.
//

import SwiftUI
import Foundation
import HealthKit
import HealthKitUI

struct StatisticCircleView: View {
    var iconName: String
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    @Environment(\.scenePhase) private var scenePhase
    
    init(iconName: String, fitagotchi: FiTagotchiData) {
        self.iconName = iconName
    }

    var body: some View {
        ZStack {
            if self.iconName == "heart.fill" {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.gray)
                    .frame(width: 30, height: 30)

                Circle()
                    .trim(from: 0.0, to: CGFloat(fiTagotchiData.completionPercentage))
                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(getColor(value: fiTagotchiData.completionPercentage))
                    .frame(width: 30, height: 30)

                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(getColor(value: fiTagotchiData.completionPercentage))
                    .frame(width: 15, height: 15)
            }
        }
        .onAppear() {
            if !fiTagotchiData.isCurrentTimeBetweenStartAndEnd() {
                fiTagotchiData.increaseCompletionPercentage()
                fiTagotchiData.updateCompletionPercentage()
            }
        }
    }

    func getColor(value: Double) -> Color {
        if value <= 0.4 {
            return .red
        } else if value <= 0.7 {
            return .yellow
        } else {
            return .green
        }
    }
    
}
