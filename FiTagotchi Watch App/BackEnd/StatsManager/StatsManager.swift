//
//  StatsManager.swift
//  FiTagotchi Watch App
//
//  Created by Simone Micillo on 13/03/24.
//

import Foundation
import SwiftUI

class StatsManager {
    static func calcNewStepStat() -> Double {
        var numSteps: Double = 0.0
        
        let stepCount = UserDefaults.standard.double(forKey: UserDefaultsKeys.stepCount)
        if stepCount != 0 {
            let lastAccessStepCount = UserDefaults.standard.double(forKey: UserDefaultsKeys.lastAccessStepCount)
            if lastAccessStepCount != 0 {
                print("--- Step Calculation: ")
                print("step (last access) = ", lastAccessStepCount)
                print("step (actual access) = ", stepCount)
                print("step difference =", stepCount - lastAccessStepCount)
                
                numSteps = stepCount - lastAccessStepCount
                UserDefaults.standard.set(stepCount, forKey: UserDefaultsKeys.lastAccessStepCount)
                return numSteps
            } else {
                UserDefaults.standard.set(stepCount, forKey: UserDefaultsKeys.lastAccessStepCount)
                numSteps = stepCount
                return numSteps
            }
        } else {
            return 0.0
        }
    }
}
