//
//  GameState.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 28/02/24.
//

import Foundation

enum GameState: String {
    case Egg
    case CreatureIdle
    case Lose
    case Win
    case EggTransition
    case LoseTransition
    case WinTransition
    case Sleeping
    
    init() {
        self = .Egg
    }
}
