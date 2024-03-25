//
//  Sad3Scene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 18/03/24.
//

import Foundation
import SpriteKit
import SwiftUI

class Sad3Scene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var creatureNode: SKSpriteNode!
    private var shadowNode: SKSpriteNode!
    
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
        shadowNode.position = CGPoint(x: size.width / 1.93, y: size.height / 2.3)
        addChild(shadowNode)
        
        creatureNode = SKSpriteNode(texture: SKTexture(imageNamed: "sad3_1"))
        creatureNode.size = CGSize(width: 150, height: 125)
        creatureNode.position = CGPoint(x: size.width / 1.95, y: size.height / 2.08)
        addChild(creatureNode)
    }
        
    private func startIdleAnimation() {
        let sadFrames = (1...5).map { "sad3_\($0)" }
        let sadTextures = sadFrames.map { SKTexture(imageNamed: $0) }
        let sadAction = SKAction.repeatForever(SKAction.animate(with: sadTextures, timePerFrame: 0.08))
        creatureNode.run(sadAction, withKey: "sadAnimation")
    }
    
}
