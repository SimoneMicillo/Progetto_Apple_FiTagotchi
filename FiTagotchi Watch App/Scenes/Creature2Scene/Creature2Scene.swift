//
//  Creature2Scene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 06/03/24.
//

import Foundation
import SpriteKit
import SwiftUI

class Creature2Scene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var creatureNode: SKSpriteNode!
    private var shadowNode: SKSpriteNode!
    private var isInteracting: Bool = false
    
    // Variabili pper update
    var lastTime: TimeInterval = 0
    @Binding var startInteraction: Bool
    
    init(size: CGSize, startInteraction: Binding<Bool>) {
        self._startInteraction = startInteraction
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        setupScene()
        
        setupCreature()
        startIdleAnimation()
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
    
    private func setupCreature() {
        shadowNode = SKSpriteNode(texture: SKTexture(imageNamed: "shadow"))
        shadowNode.size = CGSize(width: 135, height: 115)
        shadowNode.position = CGPoint(x: size.width / 1.65, y: size.height / 2)
        addChild(shadowNode)
        
        creatureNode = SKSpriteNode(texture: SKTexture(imageNamed: "frame2_1"))
        creatureNode.size = CGSize(width: 170, height: 140)
        creatureNode.position = CGPoint(x: size.width / 2, y: size.height / 2.2)
        addChild(creatureNode)
    }
        
    private func startIdleAnimation() {
        let idleFrames = (1...12).map { "frame2_\($0)" }
        let idleTextures = idleFrames.map { SKTexture(imageNamed: $0) }
        let idleAction = SKAction.repeatForever(SKAction.animate(with: idleTextures, timePerFrame: 0.1))
        creatureNode.run(idleAction, withKey: "idleAnimation")
    }
    
    private func startInteractionAnimation() {
        if !isInteracting {
            isInteracting = true
            creatureNode.removeAction(forKey: "idleAnimation")
        
            let interactionFrames = (12...24).map { "frame2_\($0)" }
            let interactionTextures = interactionFrames.map { SKTexture(imageNamed: $0) }
            let interactionAction = SKAction.animate(with: interactionTextures, timePerFrame: 0.1)
            
            creatureNode.run(interactionAction, completion: { [weak self] in
                self?.isInteracting = false
                self?.startIdleAnimation()
                self?.startInteraction = false
            })
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime == 0 {
            lastTime = currentTime
        }
        if currentTime - lastTime > 0.1 {
            if startInteraction {
                startInteractionAnimation()
            }
        }
    }
    
}
