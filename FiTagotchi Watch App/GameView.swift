//
//  GameView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 22/02/24.
//

import SwiftUI
import SpriteKit
import WatchConnectivity

enum HapticFeedbackType {
    case notification
    case success
    case failure
    case retry
    case start
    case stop
}

struct GameView: View {
    let widthD: Double
    let heightD: Double
    
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    // Variabile per comunicare con le Scene
    @State var startInteraction: Bool = false
    @State var startRocketAction: Bool = false
    @State var eggState: Int = 1
    @State var firstTry: Bool = true
    @State var firstDialogueLabel: Int = 1
    @State var showDialogue: Bool = false
    
    
    var eggScene: SKScene {
        let scene = EggScene(size: CGSize(width: 300, height: 300), newEggState: $eggState)
        return scene
    }
    
    var eggTransitionScene: SKScene {
        let scene = EggTransitionScene(size: CGSize(width: 300, height: 300))
        return scene
    }
    
    var idleScene: SKScene {
        if fiTagotchiData.fitagotchiIndex == 1 {
            let scene = Creature1Scene(size: CGSize(width: 300, height: 300), startInteraction: $startInteraction)
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 2 {
            let scene = Creature2Scene(size: CGSize(width: 300, height: 300), startInteraction: $startInteraction)
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 3 {
            let scene = Creature3Scene(size: CGSize(width: 300, height: 300), startInteraction: $startInteraction)
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 4 {
            let scene = Creature4Scene(size: CGSize(width: 300, height: 300), startInteraction: $startInteraction)
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 5 {
            let scene = Creature5Scene(size: CGSize(width: 300, height: 300), startInteraction: $startInteraction)
            return scene
        } else {
            let scene = Creature1Scene(size: CGSize(width: 300, height: 300), startInteraction: $startInteraction)
            return scene
        }
    }
    
    var sadScene: SKScene {
        if fiTagotchiData.fitagotchiIndex == 1 {
            let scene = Sad1Scene(size: CGSize(width: 300, height: 300))
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 2 {
            let scene = Sad2Scene(size: CGSize(width: 300, height: 300))
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 3 {
            let scene = Sad3Scene(size: CGSize(width: 300, height: 300))
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 4 {
            let scene = Sad4Scene(size: CGSize(width: 300, height: 300))
            return scene
        } else if fiTagotchiData.fitagotchiIndex == 5 {
            let scene = Sad5Scene(size: CGSize(width: 300, height: 300))
            return scene
        } else {
            let scene = Sad1Scene(size: CGSize(width: 300, height: 300))
            return scene
        }
    }
    
    var loseScene: SKScene {
        let scene = LoseScene(size: CGSize(width: 300, height: 300))
        return scene
    }
    
    var loseTransitionScene: SKScene {
        let scene = LoseTransitionScene(size: CGSize(width: 300, height: 300))
        return scene
    }
    
    var winScene: SKScene {
        let scene = WinScene(size: CGSize(width: 300, height: 300))
        return scene
    }
    
    var winTransitionScene: SKScene {
        let scene = WinTransitionScene(size: CGSize(width: 300, height: 300))
        return scene
    }
    
    var sleepingScene: SKScene {
        let scene = SleepingScene(size: CGSize(width: 300, height: 300))
        return scene
    }
    
    var dialogueCloudScene: SKScene {
        let scene = DialogueCloudScene(size: CGSize(width: 300, height: 300), showDialogue: fiTagotchiData.showDialogue, isClosed: fiTagotchiData.isClosed, labelState: $firstDialogueLabel)
        return scene
    }
    
    let eggSceneTimer = Timer.publish(every: 8.5, on: .main, in: .common).autoconnect()
    let sceneTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    let checkCondTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Usa currentState per determinare quale scena mostrare
            if fiTagotchiData.currentState == .Egg {
                SpriteView(scene: eggScene)
                    .frame(width: widthD, height: heightD)
                    .contentShape(Rectangle()) // Imposta la forma dell'area interattiva
                    .onTapGesture { tapLocation in
                        // Calcola l'area valida per il tocco (rect al centro dell'interfaccia)
                        let rectWidth = widthD * 0.6 // Ad esempio, impostato al 60% della larghezza del dispositivo
                        let rectHeight = rectWidth * 1.5 // Ad esempio, altezza maggiore rispetto alla larghezza
                        
                        let rectX = (widthD - rectWidth) / 2 // Centrato orizzontalmente
                        let rectY = (heightD - rectHeight) / 2 // Centrato verticalmente
                        
                        let eggRect = CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
                        
                        // Controlla se il tocco è all'interno dell'area dell'uovo
                        if eggRect.contains(tapLocation) {
                            eggState += 1
                            if eggState == 4 {
                                // Aggiunge il controllo per la vibrazione del feedback aptico
                                if fiTagotchiData.hapticFeedbackEnabled {
                                    // Chiamata a playHapticFeedback con il tipo desiderato
                                    playHapticFeedback(type: .success)
                                }
                                fiTagotchiData.fitagotchiIndex = Int.random(in: 1...5)
                                // Per forzare una creatura ad uscire dall'uovo
//                                fiTagotchiData.fitagotchiIndex = 1
                                fiTagotchiData.currentState = .EggTransition
                            } else {
                                // Aggiunge il controllo per la vibrazione del feedback aptico
                                if fiTagotchiData.hapticFeedbackEnabled {
                                    // Chiamata a playHapticFeedback con il tipo desiderato
                                    playHapticFeedback(type: .notification)
                                }
                            }
                        }
                    }
                    .allowsHitTesting(true) // Consente il rilevamento del tocco solo nell'area specificata
            } else if fiTagotchiData.currentState == .EggTransition {
                SpriteView(scene: eggTransitionScene)
                    .frame(width: widthD, height: heightD)
            } else if fiTagotchiData.currentState == .CreatureIdle {
                if fiTagotchiData.completionPercentage > 0.3 {
                    SpriteView(scene: idleScene)
                        .frame(width: widthD, height: heightD)
                        .contentShape(Rectangle())
                        .onTapGesture { tapLocation in
                            let rectWidth = widthD * 0.5
                            let rectHeight = rectWidth * 0.8
                            let rectX = (widthD - rectWidth) / 2.1
                            let rectY = (heightD - rectHeight) / 1.8
                            
                            let creatureRect = CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
                            
                            if creatureRect.contains(tapLocation) {
                                if !startInteraction {
                                    startInteraction = true
                                    // Aggiunge il controllo per la vibrazione del feedback aptico
                                    if fiTagotchiData.hapticFeedbackEnabled {
                                        // Chiamata a playHapticFeedback con il tipo desiderato
                                        playHapticFeedback(type: .success)
                                    }
                                }
                            }
                        }
                } else {
                    SpriteView(scene: sadScene)
                        .frame(width: widthD, height: heightD)
                }
                
                // Questa Scene mostra il dialogo iniziale con la creature
                // Si presenta solo la prima volta che l'utente inzia
                if !fiTagotchiData.notFirstTry {
                    SpriteView(scene: dialogueCloudScene)
                        .frame(width: widthD, height: heightD)
                        .onTapGesture { tapLocation in
                            if !fiTagotchiData.showDialogue {
                                // Rettangolo per la finestra di dialogo
                                let rect2Width = widthD * 0.3
                                let rect2Height = rect2Width * 0.8
                                let rect2X = (widthD - rect2Width) / 2
                                let rect2Y = (heightD - rect2Height) / 5.3
                                
                                let dialogueRect = CGRect(x: rect2X, y: rect2Y, width: rect2Width, height: rect2Height)
                                if dialogueRect.contains(tapLocation) {
                                    if firstTry {
                                        print("Dialogo aperto.")
                                        fiTagotchiData.showDialogue = true
                                    }
                                }
                            }
                            
                            if !fiTagotchiData.showDialogue {
                                // Rettangolo per la creatura
                                let rectWidth = widthD * 0.5
                                let rectHeight = rectWidth * 0.8
                                let rectX = (widthD - rectWidth) / 2.1
                                let rectY = (heightD - rectHeight) / 1.8
                                
                                let creatureRect = CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
                                
                                if creatureRect.contains(tapLocation) {
                                    if !startInteraction {
                                        startInteraction = true
                                        // Aggiunge il controllo per la vibrazione del feedback aptico
                                        if fiTagotchiData.hapticFeedbackEnabled {
                                            // Chiamata a playHapticFeedback con il tipo desiderato
                                            playHapticFeedback(type: .success)
                                        }
                                    }
                                }
                            }
                            
                            if fiTagotchiData.showDialogue {
                                // Rettangolo per far chiudere la finestra di dialogo
                                let rect3Width = widthD * 1.2
                                let rect3Height = rect3Width * 0.3
                                let rect3X = (widthD - rect3Width) / 2
                                let rect3Y = (heightD - rect3Height) / 1
                                
                                let windowDialogRect = CGRect(x: rect3X, y: rect3Y, width: rect3Width, height: rect3Height)
                                if windowDialogRect.contains(tapLocation) {
                                    firstDialogueLabel += 1
                                    print(firstDialogueLabel)
                                    if firstDialogueLabel == 10 {
                                        print("Finestra chiusa")
                                        fiTagotchiData.notFirstTry = true
                                        fiTagotchiData.showDialogue = false
                                    }
                                }
                            }
                        }
                }
            } else if fiTagotchiData.currentState == .Sleeping {
                SpriteView(scene: sleepingScene)
                    .frame(width: widthD, height: heightD)
            } else if fiTagotchiData.currentState == .Lose {
                SpriteView(scene: loseScene)
                    .frame(width: widthD, height: heightD)
                    .onTapGesture {
                        // Aggiunge il controllo per la vibrazione del feedback aptico
                        if fiTagotchiData.hapticFeedbackEnabled {
                            // Chiamata a playHapticFeedback con il tipo desiderato
                            playHapticFeedback(type: .failure)
                        }
                        fiTagotchiData.currentState = .LoseTransition
                    }
            } else if fiTagotchiData.currentState == .LoseTransition {
                SpriteView(scene: loseTransitionScene)
                    .frame(width: widthD, height: heightD)
            } else if fiTagotchiData.currentState == .Win {
                SpriteView(scene: winScene)
                    .frame(width: widthD, height: heightD)
                    .onTapGesture {
                        if !startRocketAction {
                            startRocketAction = true
                            // Aggiunge il controllo per la vibrazione del feedback aptico
                            if fiTagotchiData.hapticFeedbackEnabled {
                                // Chiamata a playHapticFeedback con il tipo desiderato
                                playHapticFeedback(type: .success)
                            }
                            
                            fiTagotchiData.currentState = .WinTransition
                        }
                    }
            } else if fiTagotchiData.currentState == .WinTransition {
                SpriteView(scene: winTransitionScene)
                    .frame(width: widthD, height: heightD)
            }
        }
        .onReceive(eggSceneTimer, perform: { _ in
            // Cambia lo stato dopo la transizione di schiusura dell'uovo
            if fiTagotchiData.currentState == .EggTransition {
                // Resetta le statistiche di gioco relative alla creatura
                fiTagotchiData.rocketProgress = 0
                fiTagotchiData.completionPercentage = 0.5
                fiTagotchiData.stepCount = 0
                fiTagotchiData.name = ""
                fiTagotchiData.currentState = .CreatureIdle
            }
        })
        .onReceive(sceneTimer, perform: { _ in
            // Cambia lo stato dopo le transizioni di vittoria e sconfitta
            if fiTagotchiData.currentState == .LoseTransition {
                fiTagotchiData.currentState = .Egg
            } else if fiTagotchiData.currentState == .WinTransition {
                fiTagotchiData.currentState = .Egg
            }
        })
        .onReceive(checkCondTimer, perform: { _ in
            // Controlla le condizioni di sconfitta e vittoria
            if fiTagotchiData.currentState == .CreatureIdle {
                if fiTagotchiData.isCurrentTimeBetweenStartAndEnd() {
                    fiTagotchiData.currentState = .Sleeping
                } else {
                    if fiTagotchiData.completionPercentage == 0.0 {
                        fiTagotchiData.currentState = .Lose
                    } else if fiTagotchiData.rocketProgress == 100 {
                        fiTagotchiData.currentState = .Win
                    }
                }
            }
            
            if fiTagotchiData.currentState == .Sleeping {
                // Controlla se non si è più nella fascia oraria di sonno
                if !fiTagotchiData.isCurrentTimeBetweenStartAndEnd() {
                    fiTagotchiData.currentState = .CreatureIdle
                }
            }
        })
    }
    
    // Funzione per gestire il feedback aptico
    func playHapticFeedback(type: HapticFeedbackType) {
        switch type {
        case .notification:
            WKInterfaceDevice.current().play(.notification)
        case .success:
            WKInterfaceDevice.current().play(.success)
        case .failure:
            WKInterfaceDevice.current().play(.failure)
        case .retry:
            WKInterfaceDevice.current().play(.retry)
        case .start:
            WKInterfaceDevice.current().play(.start)
        case .stop:
            WKInterfaceDevice.current().play(.stop)
        }
    }
    
}

#Preview {
    GameView(widthD: 300, heightD: 300)
}

// Codice da utilizzare per presentare una scena di SpriteKit in SwiftUI
//    var scene: SKScene {
//        let scene = GameScene(size: CGSize(width: 300, height: 300))
//        scene.scaleMode = .aspectFill
//        return scene
        // Se si utilizza il file .sks
        // Genera un numero casuale tra 1 e 3 per selezionare uno dei tamagotchi
//        let tamagotchiIndex = Int(arc4random_uniform(3)) + 1
//        let scene = SKScene(fileNamed: "Creature\(tamagotchiIndex)Scene")
//        scene!.size = CGSize(width: 300, height: 300)
//        scene?.scaleMode = .aspectFill
//        return scene!
//    }
