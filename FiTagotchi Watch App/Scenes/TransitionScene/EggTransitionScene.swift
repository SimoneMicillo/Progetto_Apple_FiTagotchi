//
//  eggTransitionScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 06/03/24.
//

import Foundation
import SpriteKit

class EggTransitionScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var eggNode: SKSpriteNode!
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
        eggNode = SKSpriteNode(texture: SKTexture(imageNamed: "egg_4"))
        eggNode.size = CGSize(width: 180, height: 150)
        eggNode.position = CGPoint(x: size.width / 1.95, y: size.height / 1.9)
        addChild(eggNode)
    }
    
    private func setupImages() {
        // Aggiunge uno sprite nero come sfondo
        blackSprite = SKSpriteNode(color: .black, size: size)
        blackSprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        blackSprite.alpha = 0.0
        addChild(blackSprite)
        
        // Aggiunge l'immagine "label1"
        labelNode = SKSpriteNode(imageNamed: "label1")  // Sostituisci con il nome reale dell'immagine
        labelNode.size = CGSize(width: 300, height: 250)
        labelNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        labelNode.alpha = 0.0
        addChild(labelNode)
    }
    
    private func runTransitionAnimation() {
        let fadeInAction1 = SKAction.fadeIn(withDuration: 2.0)
        let waitAction1 = SKAction.wait(forDuration: 7.0)
        
        let sequenceBlackSpriteAction = SKAction.sequence([fadeInAction1, waitAction1])
        blackSprite.run(sequenceBlackSpriteAction, completion: {
            self.blackSprite.removeFromParent()
        })
        
        let waitAction2_1 = SKAction.wait(forDuration: 2.0)
        let fadeInAction2 = SKAction.fadeIn(withDuration: 2.0)
        let waitAction2_2 = SKAction.wait(forDuration: 4.0)
        let fadeOutAction1 = SKAction.fadeOut(withDuration: 0.3)
        
        let sequenceLabelAction = SKAction.sequence([waitAction2_1, fadeInAction2, waitAction2_2])
        labelNode.run(sequenceLabelAction, completion: {
            UserDefaults.standard.setValue(Date(), forKey: "formerInactiveHealth")
            UserDefaults.standard.setValue(Date(), forKey: "formerInactiveRocket")
            UserDefaults.standard.setValue(Date(), forKey: "latestInactiveTime")
            self.labelNode.run(fadeOutAction1)
        })
    }
}
