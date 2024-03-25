//
//  FiTagotchiApp.swift
//  FiTagotchi Watch App
//
//  Created by Davide Dolce on 14/02/24.
//

import SwiftUI

@main
struct FiTagotchi_Watch_AppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FiTagotchiData())  // Passaggio di FiTagotchiData come EnvironmentObject
        }
    }
}
