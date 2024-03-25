//
//  SleepingScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 14/03/24.
//

import Foundation
import SwiftUI
import SpriteKit

class SleepingScene: SKScene {
    
    private var tentNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        setupScene()

        setupTent()
        startTentAnimation()
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
    
    private func setupTent() {
        tentNode = SKSpriteNode(texture: SKTexture(imageNamed: "tent_1"))
        tentNode.size = CGSize(width: 270, height: 230)
        tentNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(tentNode)
    }
    
    private func startTentAnimation() {
        let tentFrames = (2...23).map { "tent_\($0)" }
        let tentTextures = tentFrames.map { SKTexture(imageNamed: $0) }
        let tentAction = SKAction.repeatForever(SKAction.animate(with: tentTextures, timePerFrame: 0.1))
        tentNode.run(tentAction, withKey: "tentAnimation")
    }
    
}
