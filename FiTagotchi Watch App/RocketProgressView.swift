//
//  RocketProgressView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 04/03/24.
//

import SwiftUI
import WidgetKit

struct RocketProgressView: View {
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                RocketView(widthD: geometry.size.width, heightD: geometry.size.height)
                    .background(.white)
                
                VStack {
                    
                    Spacer()
                        .padding(.top, geometry.size.height - 50/*80*/)
                    
                    // Pannelli fittizi per aumentare/diminuire il progresso del razzo
//                    HStack() {
//                        Text("- 10")
//                            .font(.subheadline)
//                            .padding(5)
//                            .onTapGesture(perform: {
//                                if fiTagotchiData.rocketProgress > 0 {
//                                    if (fiTagotchiData.rocketProgress - 10) < 0 {
//                                        fiTagotchiData.rocketProgress = 0
//                                    } else {
//                                        fiTagotchiData.rocketProgress -= 10
//                                    }
//                                }
//                            })
//                        
//                        Spacer()
//                        
//                        Text("+ 10")
//                            .font(.subheadline)
//                            .padding(5)
//                            .onTapGesture(perform: {
//                                if fiTagotchiData.rocketProgress < 100 {
//                                    if (fiTagotchiData.rocketProgress + 10) > 100 {
//                                        fiTagotchiData.rocketProgress = 100
//                                    } else {
//                                        fiTagotchiData.rocketProgress += 10
//                                    }
//                                }
//                            })
//                    }
//                    .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 30))
//                    .padding(.horizontal, 40)
                    
                    ProgressBar(width: geometry.size.width, height: CGFloat(15))
                }
            }
            .ignoresSafeArea()
            .onAppear() {
                if !fiTagotchiData.isCurrentTimeBetweenStartAndEnd() {
                    fiTagotchiData.updateRocketProgress()
                }
            }
        }
    }
}


#Preview {
    RocketProgressView()
}
