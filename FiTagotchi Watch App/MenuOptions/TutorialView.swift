//
//  TutorialView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 01/03/24.
//

import SwiftUI

struct TutorialPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let height: Double
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        ScrollView {
            VStack {
                Image(page.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: page.height)
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 5)
                
                Text(page.description)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle(page.title)
    }
}

struct TutorialPageView_Previews: PreviewProvider {
    static var previews: some View {
        let page = TutorialPage(imageName: "tutorial_1", title: "Creature health", description: """
Your creature depletes its health over the course of hours of activity to build the rocket. By taking steps, you help to maintain this value high. If the health drops to zero, the creature will decide to leave and seek help elsewhere.
""", height: 70)
        TutorialPageView(page: page)
    }
}

struct TutorialView: View {

    let tutorialPages = [
        TutorialPage(imageName: "tutorial_1", title: "Creature health", description: """
Your creature depletes its health over the course of hours of activity to build the rocket. By taking steps, you help to maintain this value high. If the health drops to zero, the creature will decide to leave and seek help elsewhere.
""", height: 70),
        TutorialPage(imageName: "tutorial_2", title: "Sleep schedule", description: """
In Settings, you can set the time you go to sleep and the time you wake up. The creature will consume its health only during waking hours (hours of activity). The progress of rocket construction will not increase during sleep hours.
""", height: 80),
        TutorialPage(imageName: "tutorial_3", title: "Rocket progress", description: """
Your goal is to help the creature return to its home planet. Keep its health above zero until the progress reaches 100%. The rocket construction progress only increases during the hours when the creature is awake.
""", height: 90),
        TutorialPage(imageName: "tutorial_4", title: "Daily Missions", description: """
In the 'Missions' section, you'll find a list of challenges that reset daily. Upon completing a mission's goal, a message will appear, and the specified coins will be automatically added to your balance. The balance is visible within the 'Food' section.
""", height: 90),
        TutorialPage(imageName: "tutorial_5", title: "Coins and food", description: """
With coins earned by completing daily challenges in the 'Missions' section, you can purchase food within the 'Food' section. Purchased food will be visible in your Bag. You can consume them to increase the health value of your creature by a certain percentage.
""", height: 90),
        // Aggiungi altre slide secondo necessità
    ]

    var body: some View {
        List {
            ForEach(tutorialPages) { page in
                NavigationLink(destination: TutorialPageView(page: page)) {
                    Text(page.title)
                }
            }
        }
        .navigationTitle("Tutorial")
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
