//
//  LoseTransitionScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 07/03/24.
//

import Foundation
import SpriteKit

class LoseTransitionScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var mailNode: SKSpriteNode!
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
        let backgroundNode = SKSpriteNode(imageNamed: "background1")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backgroundNode)
        mailNode = SKSpriteNode(texture: SKTexture(imageNamed: "mail"))
        mailNode.size = CGSize(width: 160, height: 140)
        mailNode.position = CGPoint(x: size.width / 2, y: size.height / 2.2)
        addChild(mailNode)
    }
    
    private func setupImages() {
        // Aggiunge uno sprite nero come sfondo
        blackSprite = SKSpriteNode(color: .black, size: size)
        blackSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blackSprite.alpha = 0.0
        addChild(blackSprite)
        
        // Aggiunge l'immagine "label3"
        labelNode = SKSpriteNode(imageNamed: "label3")
        labelNode.size = CGSize(width: 300, height: 250)
        labelNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        labelNode.alpha = 0.0
        addChild(labelNode)
    }
    
    private func runTransitionAnimation() {
        let fadeInAction1 = SKAction.fadeIn(withDuration: 2.0)
        let waitAction1 = SKAction.wait(forDuration: 8.0)
        let removeAction1 = SKAction.removeFromParent()
        
        let sequenceBlackSpriteAction = SKAction.sequence([fadeInAction1, waitAction1, removeAction1])
        blackSprite.run(sequenceBlackSpriteAction)
        
        let waitAction2_1 = SKAction.wait(forDuration: 2.0)
        let fadeInAction2 = SKAction.fadeIn(withDuration: 2.0)
        let waitAction2_2 = SKAction.wait(forDuration: 7.0)
        let removeAction2 = SKAction.removeFromParent()
        
        let sequenceLabelAction = SKAction.sequence([waitAction2_1, fadeInAction2, waitAction2_2, removeAction2])
        labelNode.run(sequenceLabelAction)
    }
}
