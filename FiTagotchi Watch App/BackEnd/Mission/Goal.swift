//
//  Goal.swift
//  FiTagotchi Watch App
//
//  Created by Davide Perrotta on 09/03/24.
//

import Foundation
import SwiftUI


struct Goal: Hashable {
    let title: String
    let icon: String
    let goalType: GoalType
    var coins: Int
    let goal: Int
    let coinsEarned: Int
}

enum GoalType: String {
    case stepCount
    case flightsClimbed
    case activeEnergyBurned
    case standMinutes
    case restingHeartRate
    case distanceWalkingRunning
    case dailyReward
}
