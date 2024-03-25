//
//  InterfaceController.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 07/03/24.
//

//import Foundation
//import WatchKit
//
//class InterfaceController: WKInterfaceController {
//
//    enum HapticFeedbackType {
//        case notification
//        case success
//        case failure
//        case retry
//        // Aggiungi altri tipi di feedback aptico se necessario
//    }
//
//    @IBAction func notificationButtonTapped() {
//        playHapticFeedback(type: .notification)
//        // Aggiungi altre azioni specifiche della tua scena
//    }
//
//    @IBAction func successButtonTapped() {
//        playHapticFeedback(type: .success)
//        // Aggiungi altre azioni specifiche della tua scena
//    }
//
//    @IBAction func failureButtonTapped() {
//        playHapticFeedback(type: .failure)
//        // Aggiungi altre azioni specifiche della tua scena
//    }
//
//    @IBAction func retryButtonTapped() {
//        playHapticFeedback(type: .retry)
//        // Aggiungi altre azioni specifiche della tua scena
//    }
//
//    // Funzione per gestire il feedback aptico
//    func playHapticFeedback(type: HapticFeedbackType) {
//        switch type {
//        case .notification:
//            WKInterfaceDevice.current().play(.notification)
//        case .success:
//            WKInterfaceDevice.current().play(.success)
//        case .failure:
//            WKInterfaceDevice.current().play(.failure)
//        case .retry:
//            WKInterfaceDevice.current().play(.retry)
//        // Aggiungi altri casi per gestire tipi di feedback aptici aggiuntivi
//        }
//    }
//}
