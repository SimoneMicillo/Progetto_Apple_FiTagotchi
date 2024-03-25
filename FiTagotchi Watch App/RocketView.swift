//
//  RocketView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 04/03/24.
//

import SwiftUI
import SpriteKit

struct RocketView: View {
    let widthD: Double
    let heightD: Double
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
//    var rocketPieces: SKScene {
//        let scene = RocketScene(size: CGSize(width: 300, height: 300))
//        scene.scaleMode = .aspectFill
//        return scene
//    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: RocketScene(size: CGSize(width: 300, height: 300), rocketProgress: $fiTagotchiData.rocketProgress))
                .frame(width: widthD, height: heightD)
        }
    }
}

#Preview {
    RocketView(widthD: 300, heightD: 300)
}
