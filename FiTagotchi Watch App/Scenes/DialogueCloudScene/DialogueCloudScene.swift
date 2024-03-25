//
//  DialogueCloud1Scene.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 11/03/24.
//

import Foundation
import SpriteKit
import SwiftUI

class DialogueCloudScene: SKScene {
    
    private var dialogueCloudNode: SKSpriteNode!
    private var labelNode: SKSpriteNode!
    
    // Variabili per update
    var lastTime: TimeInterval = 0
    var showDialogue: Bool
    var isClosed: Bool
    @Binding var labelState: Int
    
    init(size: CGSize, showDialogue: Bool, isClosed: Bool, labelState: Binding<Int>) {
        self.showDialogue = showDialogue
        self.isClosed = isClosed
        self._labelState = labelState
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        setupScene()
    }
    
    private func setupScene() {
        // Imposta lo sfondo trasparente
        backgroundColor = SKColor.clear

        // Aggiungi la nuvola di dialogo o altri elementi della scena overlay
        dialogueCloudNode = SKSpriteNode(imageNamed: "cloud_1")
        dialogueCloudNode.size = CGSize(width: 300, height: 260)
        dialogueCloudNode.position = CGPoint(x: size.width / 2, y: size.height / 2.2)
        addChild(dialogueCloudNode)
    }
    
    private func showDialogueWindow() {
        let showFrames = (2...22).map { "cloud_\($0)" }
        let showTextures = showFrames.map { SKTexture(imageNamed: $0) }
        let lastFrame = SKTexture(imageNamed: "label1_1")
        let allTextures = showTextures + [lastFrame]
        let showAction = SKAction.animate(with: allTextures, timePerFrame: 0.06)
        let lastTexture = allTextures.last
            
        dialogueCloudNode.run(showAction, completion: { [weak self] in
            // Impostare manualmente l'ultima texture come texture corrente
            self?.dialogueCloudNode.texture = lastTexture
            // Impostare showDialogue a false alla fine dell'animazione
            self?.isClosed = false
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime == 0 {
            lastTime = currentTime
        }
        if currentTime - lastTime > 0.1 {
            if self.showDialogue && self.isClosed {
                showDialogueWindow()
            }
            
            if labelState > 1 && labelState < 10 {
                let currentLabelIndex = labelState
                let labelFrame = "label1_\(currentLabelIndex)"
                
                // Cambia l'immagine solo se è diversa dall'immagine corrente
                if dialogueCloudNode?.texture?.description != SKTexture(imageNamed: labelFrame).description {
                    let newLabelState = SKSpriteNode(imageNamed: labelFrame)
                    newLabelState.size = CGSize(width: 300, height: 260)
                    newLabelState.position = CGPoint(x: size.width / 2, y: size.height / 2.2)
                    
                    // Aggiunge il nuovo frame e rimuove quello precedente
                    addChild(newLabelState)
                    dialogueCloudNode?.removeFromParent()
                    dialogueCloudNode = newLabelState
                }
            }
        }
    }
}
