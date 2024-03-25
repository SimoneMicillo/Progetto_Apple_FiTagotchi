//
//  RocketScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 04/03/24.
//

import Foundation
import SpriteKit
import SwiftUI

class RocketScene: SKScene {
    @Binding var rocketProgress: Double
    
    private var backgroundNode: SKSpriteNode!
    private var rocketPart: SKSpriteNode?
    
    init(size: CGSize, rocketProgress: Binding<Double>) {
        self._rocketProgress = rocketProgress
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        setupScene()
    }

    private func setupScene() {
        // Aggiunge lo sfondo
        let blackBackgroundNode = SKSpriteNode(color: .black, size: size)
        blackBackgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(blackBackgroundNode)
        let backgroundNode = SKSpriteNode(imageNamed: "background2")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgroundNode)
        
        updateRocket()
    }
    
    private func updateRocket() {
        // Verifica se il progresso è inferiore al 20%
        guard rocketProgress >= 20 else {
            // Nascondi il razzo se il progresso è inferiore al 20%
            rocketPart?.removeFromParent()
            rocketPart = nil
            return
        }

        // Determina quale immagine del razzo mostrare
        let currentPartIndex = Int(rocketProgress / 20)
        let imageName = "piece_\(currentPartIndex)"
        
        // Cambia l'immagine solo se è diversa dall'immagine corrente
        if rocketPart?.texture?.description != SKTexture(imageNamed: imageName).description {
            let newRocketPart = SKSpriteNode(imageNamed: imageName)
            newRocketPart.position = CGPoint(x: size.width / 1.9, y: size.height / 1.8)
            // Regola la dimensione del razzo (scala del 90%)
            newRocketPart.setScale(0.9)
            
            // Aggiunge il nuovo pezzo e rimuove quello precedente
            addChild(newRocketPart)
            rocketPart?.removeFromParent()
            rocketPart = newRocketPart
        }
    }
}
