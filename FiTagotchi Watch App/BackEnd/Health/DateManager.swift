//
//  DateManager.swift
//  FiTagotchi Watch App
//
//  Created by Simone Micillo on 04/03/24.
//

import SwiftUI

class DateManager {
    
    private var dateDiff : DateComponents = DateComponents()
    var fiTagotchiData: FiTagotchiData!
    
    func updateDates(scenePhase: ScenePhase)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd HH:mm:ss"

        //ESEGUE SOLO QUANDO L'APP PASSA ALLO STATO ATTIVO QUINDI QUANDO VIENE AVVIATA
        if scenePhase == .background
        {
            UserDefaults.standard.set(Date(), forKey: "latestInactiveTime")
            print("Salvato: ",dateFormatter.string(from: Date()))
        }
        else if scenePhase == .active
        {
            if let retrievedData = UserDefaults.standard.object(forKey: "latestInactiveTime") as? Date {
                // L'oggetto Date è stato recuperato con successo
                print("Oggetto Data recuperato:", dateFormatter.string(from: retrievedData))
                UserDefaults.standard.set(retrievedData, forKey: "formerInactiveTime")
                UserDefaults.standard.set(retrievedData, forKey: "formerInactiveHealth")
                UserDefaults.standard.set(retrievedData, forKey: "formerInactiveRocket")
                UserDefaults.standard.set(Date(), forKey: "latestInactiveTime")
            } else {
                print("Oggetto Data non esistente.")
                UserDefaults.standard.setValue(Date(), forKey: "formerInactiveTime")
                UserDefaults.standard.setValue(Date(), forKey: "formerInactiveHealth")
                UserDefaults.standard.setValue(Date(), forKey: "formerInactiveRocket")
            }
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func calcDateDiff() -> DateComponents
    {
        var difference : DateComponents = DateComponents()
        
        if let retrievedData = UserDefaults.standard.object(forKey: "latestInactiveTime") as? Date{
            
            if let formerDate = UserDefaults.standard.object(forKey: "formerInactiveTime") as? Date {
                
                difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: formerDate, to: retrievedData)
                
                // Estrai la differenza in ore, minuti e secondi
                let days = difference.day ?? 0
                let hours = difference.hour ?? 0
                let minutes = difference.minute ?? 0
                let seconds = difference.second ?? 0
                
                // Stampa la differenza
                print("Differenza: \(days) giorni, \(hours) ore, \(minutes) minuti, \(seconds) secondi")
                
            } else {
                // Nessun dato trovato per la chiave specificata
                // Calcola la differenza tra le due date
                let currentDate = Date()
                
                difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: retrievedData, to: currentDate)
                
                // Estrai la differenza in ore, minuti e secondi
                let days = difference.day ?? 0
                let hours = difference.hour ?? 0
                let minutes = difference.minute ?? 0
                let seconds = difference.second ?? 0
                
                // Stampa la differenza
                print("Differenza: \(days) giorni, \(hours) ore, \(minutes) minuti, \(seconds) secondi")
            }
        }
        
        return difference
    }
}
