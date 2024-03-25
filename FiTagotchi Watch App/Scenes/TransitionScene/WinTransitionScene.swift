//
//  WinTransitionScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 10/03/24.
//

import Foundation
import SpriteKit

class WinTransitionScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var rocketNode: SKSpriteNode!
    private var blackSprite: SKSpriteNode!
    private var labelNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        setupScene()
        setupImages()
        runTransitionAnimation()
    }
    
    private func setupScene() {
        // Aggiunge lo sfondo
        let blackBackgroundNode = SKSpriteNode(color: .black, size: size)
        blackBackgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(blackBackgroundNode)
        let backgroundNode = SKSpriteNode(imageNamed: "background2")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgroundNode)
    }
    
    private func setupImages() {
        // Aggiunge lo sprite del razzo
        rocketNode = SKSpriteNode(texture: SKTexture(imageNamed: "rocket_1"))
        rocketNode.position = CGPoint(x: size.width / 1.9, y: size.height / 1.8)
        rocketNode.setScale(0.9)
        addChild(rocketNode)
        
        // Aggiunge uno sprite nero come sfondo
        blackSprite = SKSpriteNode(color: .black, size: size)
        blackSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blackSprite.alpha = 0.0
        addChild(blackSprite)
        
        // Aggiunge l'immagine "label3"
        labelNode = SKSpriteNode(imageNamed: "label2")
        labelNode.size = CGSize(width: 300, height: 250)
        labelNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        labelNode.alpha = 0.0
        addChild(labelNode)
    }
    
    private func runTransitionAnimation() {
        let rocketFrames = (2...12).map { "rocket_\($0)" }
        let rocketTextures = rocketFrames.map { SKTexture(imageNamed: $0) }
        let startAction = SKAction.animate(with: rocketTextures, timePerFrame: 0.1)
        
        rocketNode.run(startAction) { [weak self] in
            self?.rocketNode.removeFromParent()
        }
        
        let waitAction1_1 = SKAction.wait(forDuration: 1.0)
        let fadeInAction1 = SKAction.fadeIn(withDuration: 2.0)
        let waitAction1_2 = SKAction.wait(forDuration: 6.0)
        let removeAction1 = SKAction.removeFromParent()
        
        let sequenceBlackSpriteAction = SKAction.sequence([waitAction1_1, fadeInAction1, waitAction1_2, removeAction1])
        blackSprite.run(sequenceBlackSpriteAction)
        
        let waitAction2_1 = SKAction.wait(forDuration: 3.0)
        let fadeInAction2 = SKAction.fadeIn(withDuration: 2.0)
        let waitAction2_2 = SKAction.wait(forDuration: 6.0)
        let removeAction2 = SKAction.removeFromParent()
        
        let sequenceLabelAction = SKAction.sequence([waitAction2_1, fadeInAction2, waitAction2_2, removeAction2])
        labelNode.run(sequenceLabelAction)
    }
}
