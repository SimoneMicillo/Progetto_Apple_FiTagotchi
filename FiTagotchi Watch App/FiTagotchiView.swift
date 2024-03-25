//
//  FiTagotchiView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 19/02/24.
//

import SwiftUI
import SpriteKit



struct FiTagotchiView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                GameView(widthD: geometry.size.width, heightD: geometry.size.height)
                VStack {
                    if fiTagotchiData.currentState == .CreatureIdle || fiTagotchiData.currentState == .Sleeping {
                        HStack {
                            Text(fiTagotchiData.name)
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        
                        HStack {
                            Spacer()
                            
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("\(fiTagotchiData.actualCoins)")
                                    .bold()
                                    .padding(.trailing, 3)
                            }
                            .padding(.all, 3)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.white.opacity(0.6), lineWidth: 2)
                            )
                        }
                        .padding(.top, fiTagotchiData.name == "" ? 2200 / geometry.size.height : 350 / geometry.size.height)
                    }
                    
                    Spacer()
                    
                    if (fiTagotchiData.currentState == .CreatureIdle || fiTagotchiData.currentState == .Sleeping) && !fiTagotchiData.showDialogue {
                        HStack {
                            HStack {
                                StatisticCircleView(iconName: "heart.fill", fitagotchi: fiTagotchiData)
                                    .frame(width: 20, height: 20)
                                    .padding(10)
                            }
                            .padding(.all, 3)
                            .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 30))
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)) // Modifica della spaziatura generale
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .ignoresSafeArea()
        }
    }
}
