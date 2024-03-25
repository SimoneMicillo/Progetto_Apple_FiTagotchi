//
//  EggScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 27/02/24.
//

import Foundation
import SpriteKit
import SwiftUI

class EggScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var eggNode: SKSpriteNode!
    
    // Variabili per update
    var lastTime: TimeInterval = 0
    @Binding var eggState: Int
    
    init(size: CGSize, newEggState: Binding<Int>) {
        self._eggState = newEggState
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        setupScene()

        setupEgg()
    }
    
    private func setupScene() {
        // Aggiunge lo sfondo
        let blackBackgroundNode = SKSpriteNode(color: .black, size: size)
        blackBackgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(blackBackgroundNode)
        let backgroundNode = SKSpriteNode(imageNamed: "background1")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgroundNode)
    }
    
    private func setupEgg() {
        eggNode = SKSpriteNode(texture: SKTexture(imageNamed: "egg_\(eggState)"))
        eggNode.size = CGSize(width: 180, height: 150)
        eggNode.position = CGPoint(x: size.width / 1.95, y: size.height / 1.9)
        addChild(eggNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime == 0 {
            lastTime = currentTime
        }
        if currentTime - lastTime > 0.1 {
            let currentEggIndex = eggState
            let eggFrame = "egg_\(currentEggIndex)"
            
            // Cambia l'immagine solo se è diversa dall'immagine corrente
            if eggNode?.texture?.description != SKTexture(imageNamed: eggFrame).description {
                let newEggState = SKSpriteNode(imageNamed: eggFrame)
                newEggState.size = CGSize(width: 180, height: 150)
                newEggState.position = CGPoint(x: size.width / 1.95, y: size.height / 1.9)
                
                // Aggiunge il nuovo frame e rimuove quello precedente
                addChild(newEggState)
                eggNode?.removeFromParent()
                eggNode = newEggState
            }
        }
    }
    
}
