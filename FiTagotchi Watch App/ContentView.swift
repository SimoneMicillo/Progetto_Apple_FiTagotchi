//
//  ContentView.swift
//  FiTagotchi Watch App
//
//  Created by Davide Dolce on 14/02/24.
//

import SwiftUI

struct ContentView: View {
    @State var dateDiff: DateComponents = DateComponents()
    private var dateManager: DateManager = DateManager()
    
    @StateObject var health: HealthManager = HealthManager(points: 0, heartRate: 0, flightsClimbed: 0, burnedCalories: 0, minutesExercise: 0, totalScore: 0)
    
    // Aggiunta di EnvironmentObject
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    @Environment(\.scenePhase) private var scenePhase
    
    enum Tab {
        case progressView
        case fiTagotchiView
        case menuView
    }
    
    init() {
        health.auth()       // Esegui l'autorizzazione a HealthKit durante l'inizializzazione
        health.startTimer()
    }
    
    @State private var selectedTab: Tab = .fiTagotchiView
    
    var body: some View {
        if fiTagotchiData.currentState == .Egg {
            NavigationView {
                ZStack {
                    FiTagotchiView()
                    
                    VStack(alignment: .center) {
                        Spacer()
                        
                        Text("Tap the egg to open it")
                            .padding(.all, 5)
                            .font(.footnote)
                            .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        } else if fiTagotchiData.currentState != .CreatureIdle && fiTagotchiData.currentState != .Sleeping {
            FiTagotchiView()
        } else if fiTagotchiData.currentState == .CreatureIdle || fiTagotchiData.currentState == .Sleeping {
            TabView(selection: $selectedTab) {
                NavigationView {
                    RocketProgressView()
                        .navigationBarTitle("\(Int(fiTagotchiData.rocketProgress))%")
                }
                .tag(Tab.progressView)
                
                NavigationView {
                    FiTagotchiView()
                }
                .tag(Tab.fiTagotchiView)
                
                NavigationView {
                    MenuView(health: health)
                        .navigationBarTitle("Menu")
                }
                .tag(Tab.menuView)
            }
            // Per nascondere i punti della TabView, decommenta questa riga
            //.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear() {
                health.setEnvFitData(fiTagotchiData: fiTagotchiData)
            }
            .onChange(of: scenePhase, {
                if !fiTagotchiData.isCurrentTimeBetweenStartAndEnd() {
                    dateManager.updateDates(scenePhase: scenePhase)
                    dateDiff = dateManager.calcDateDiff()
                    if scenePhase == .active {
                        fiTagotchiData.increaseCompletionPercentage()
                        fiTagotchiData.updateCompletionPercentage()
                        fiTagotchiData.updateRocketProgress()
                    }
                }
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FiTagotchiData())
    }
}
