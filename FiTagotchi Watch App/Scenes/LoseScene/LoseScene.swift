//
//  LoseScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 27/02/24.
//

import Foundation
import SpriteKit
import SwiftUI

class LoseScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var mailNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        setupScene()

        setupMail()
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
    
    private func setupMail() {
        mailNode = SKSpriteNode(texture: SKTexture(imageNamed: "mail"))
        mailNode.size = CGSize(width: 160, height: 140)
        mailNode.position = CGPoint(x: size.width / 2, y: size.height / 2.2)
        addChild(mailNode)
    }
    
}
