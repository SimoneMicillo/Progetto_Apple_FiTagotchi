//
//  WinScene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 27/02/24.
//

import Foundation
import SpriteKit
import SwiftUI

class WinScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var rocketNode: SKSpriteNode!
    
    override func sceneDidLoad() {
        setupScene()
        
        setupRocket()
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
    
    private func setupRocket() {
        rocketNode = SKSpriteNode(texture: SKTexture(imageNamed: "rocket_1"))
        rocketNode.position = CGPoint(x: size.width / 1.9, y: size.height / 1.8)
        rocketNode.setScale(0.9)
        addChild(rocketNode)
    }
    
}
