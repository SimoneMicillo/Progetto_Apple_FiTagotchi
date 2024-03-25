//
//  Sad4Scene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 18/03/24.
//

import Foundation
import SpriteKit
import SwiftUI

class Sad4Scene: SKScene {
    
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
        shadowNode.size = CGSize(width: 140, height: 105)
        shadowNode.position = CGPoint(x: size.width / 2.03, y: size.height / 2.02)
        addChild(shadowNode)
        
        creatureNode = SKSpriteNode(texture: SKTexture(imageNamed: "sad4_1"))
        creatureNode.size = CGSize(width: 155, height: 130)
        creatureNode.position = CGPoint(x: size.width / 1.98, y: size.height / 2.05)
        addChild(creatureNode)
    }
        
    private func startIdleAnimation() {
        let sadFrames = (1...12).map { "sad4_\($0)" }
        let sadTextures = sadFrames.map { SKTexture(imageNamed: $0) }
        let sadAction = SKAction.repeatForever(SKAction.animate(with: sadTextures, timePerFrame: 0.1))
        creatureNode.run(sadAction, withKey: "sadAnimation")
    }
    
}
