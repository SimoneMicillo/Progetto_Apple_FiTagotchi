//
//  FiTagotchiData.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 21/02/24.
//

import Foundation
import WidgetKit

enum Difficulty: String, CaseIterable {
    case normal = "Normal"
    case difficult = "Hard"
    
    init() {
        self = .normal
    }
}

struct UserDefaultsKeys {
    static let name = "name"
    static let coins = "coins"
    static let startTime = "startTime"
    static let endTime = "endTime"
    static let difficulty = "difficulty"
    static let hapticFeedbackEnabled = "hapticFeedbackEnabled"
    static let stepGoal = "stepGoal"
    static let actualCoins = "actualCoins"
    static let stepCount = "stepCount"
    static let rocketProgress = "rocketProgress"
    static let dateLastStepCountReset = "dateLastStepCountReset"
    static let fitagotchiIndex = "fitagotchiIndex"
    static let notFirstTry = "notFirstTry"
    static let showDialogue = "showDialogue"
    static let isClosed = "isClosed"
    static let completionPercentage = "completionPercentage"
    static let lastAccessStepCount = "lastAccessStepCount"
    static let lastResetDate = "lastResetDate"
    static let dailyAccess = "dailyAccess"
    static let lastAccessDateKey = "lastAccessDateKey"
    static let lastAccessHour = "lastAccessHour"
    static let gameState = "gameState"
}

class FiTagotchiData: ObservableObject {
    // Published properties that trigger UI updates when changed
    @Published var userStartTime = defaultStartTime
    @Published var userEndTime = defaultEndTime
    @Published var actualDifficulty: Difficulty = .normal
    @Published var inventory: Inventory = Inventory()
    
    // Variabile contenente lo stato corrente in cui si trova il gioco
    @Published var currentState: GameState = {
        if let rawValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.gameState),
            let savedState = GameState(rawValue: rawValue) {
            return savedState
        }
        return .Egg
    }() {
        didSet {
            UserDefaults.standard.set(currentState.rawValue, forKey: UserDefaultsKeys.gameState)
        }
    }
    
    var dateLastStepCountReset: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.dateLastStepCountReset) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.dateLastStepCountReset)
        }
    }

    // Variabile per le monete dell'utente
    var actualCoins: Int{
        get{
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.actualCoins)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.actualCoins)
        }
    }
    
    // Variabile per il traguardo di passi dell'utente
    @Published var stepGoal: Int = {
        if let savedValue = UserDefaults.standard.value(forKey: UserDefaultsKeys.stepGoal) as? Int {
            return savedValue
        } else {
            return 8000
        }
    }() {
        didSet{
            UserDefaults.standard.set(stepGoal, forKey: UserDefaultsKeys.stepGoal)
        }
    }
    
    // Variabile contenente il valore della salute
    @Published var completionPercentage: Double = {
        if let savedValue = UserDefaults.standard.value(forKey: UserDefaultsKeys.completionPercentage) as? Double {
            return savedValue
        } else {
            return 0.5
        }
    }() {
        didSet {
            UserDefaults.standard.set(completionPercentage, forKey: UserDefaultsKeys.completionPercentage)
            UserDefaults(suiteName: "group.health123")!.set(completionPercentage, forKey: "value")
            WidgetCenter.shared.reloadTimelines(ofKind: "ExpressionWidgetExtension")
        }
    }
    
    // Variabile contenente il valore relativo al progresso di costruzione del razzo
    @Published var rocketProgress: Double = {
        if let savedValue = UserDefaults.standard.value(forKey: UserDefaultsKeys.rocketProgress) as? Double {
            return savedValue
        } else {
            return 0
        }
    }() {
        didSet {
            UserDefaults.standard.set(rocketProgress, forKey: UserDefaultsKeys.rocketProgress)
        }
    }
    
    @Published var dailyAccess: Int = {
        if let savedAccess = UserDefaults.standard.value(forKey: UserDefaultsKeys.dailyAccess) as? Int {
            return savedAccess
        } else {
            return 0
        }
    }() {
        didSet {
            UserDefaults.standard.set(dailyAccess, forKey: UserDefaultsKeys.dailyAccess)
        }
    }
    
    // Variabile per il nome della creatura
    @Published var name: String = UserDefaults.standard.string(forKey: UserDefaultsKeys.name) ?? "" {
        didSet {
            UserDefaults.standard.set(name, forKey: UserDefaultsKeys.name)
        }
    }
    
    var coins: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.coins)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.coins)
        }
    }
    
    // Variabili per l'orario di inizio e fine sonno
    @Published var startTime: Date = {
        if let storedStartTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.startTime) as? Date {
            return storedStartTime
        } else {
            return FiTagotchiData.defaultStartTime
        }
    }() {
        didSet {
            UserDefaults.standard.set(startTime, forKey: UserDefaultsKeys.startTime)
        }
    }
    
    @Published var endTime: Date = {
        if let storedEndTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.endTime) as? Date {
            return storedEndTime
        } else {
            return FiTagotchiData.defaultEndTime
        }
    }() {
        didSet {
            UserDefaults.standard.set(endTime, forKey: UserDefaultsKeys.endTime)
        }
    }
    
    // Variabile contenente il livello di difficoltà del gioco
    var difficulty: Difficulty {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.difficulty),
                let difficulty = Difficulty(rawValue: rawValue) {
                return difficulty
            }
            return Difficulty()
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.difficulty)
        }
    }
    
    // Computed property to get/set whether haptic feedback is enabled from UserDefaults
    var hapticFeedbackEnabled: Bool {
        get {
            if let storedValue = UserDefaults.standard.value(forKey: UserDefaultsKeys.hapticFeedbackEnabled) as? Bool {
                return storedValue
            } else {
                // Se la chiave non esiste, restituisci true di default
                return true
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.hapticFeedbackEnabled)
        }
    }
    
    var stepCount: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.stepCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.stepCount)
        }
    }
    
    // Indice identificativo della creatura
    var fitagotchiIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.fitagotchiIndex)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.fitagotchiIndex)
        }
    }
    
    // Variabili per la nuvola di dialogo con la creatura
    @Published var notFirstTry: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.notFirstTry) {
        didSet {
            UserDefaults.standard.set(notFirstTry, forKey: UserDefaultsKeys.notFirstTry)
        }
    }
    
    @Published var showDialogue: Bool = false {
        didSet {
            UserDefaults.standard.set(oldValue, forKey: UserDefaultsKeys.showDialogue)
        }
    }
    
    @Published var isClosed: Bool = true {
        didSet {
            UserDefaults.standard.set(oldValue, forKey: UserDefaultsKeys.isClosed)
        }
    }
    
    // Static constants for default start and end times
    static let defaultStartTime: Date = {
        var components = DateComponents()
        components.hour = 23
        components.minute = 0
        return Calendar.current.date(from: components)!
    }()

    static let defaultEndTime: Date = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components)!
    }()
    
    // Funzione per caricare l'inventario all'inizio
    func loadInventory() {
        inventory.loadInventory()
    }
    
    // Funzione per controllare se l'orario corrente è all'interno della fascia oraria di sonno
    func isCurrentTimeBetweenStartAndEnd() -> Bool {
        // Ottieni l'orario corrente
        let currentTime = Date()

        // Ottieni ore e minuti per startTime, endTime e currentTime
        let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
        let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
        let currentTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: currentTime)
        
        // Controlla se startTime è maggiore di endTime
        if startTime > endTime {
            // 1) Se startTime è maggiore di endTime...
            // Controlla se currentTime è maggiore di startTime
            if (currentTimeComponents.hour! > startTimeComponents.hour!) || ((currentTimeComponents.hour! == startTimeComponents.hour!) && (currentTimeComponents.minute! >= startTimeComponents.minute!)) {
                // Se currentTime è >= di startTime, è nell'intervallo
                return true
            } else {
                // Se currentTime è minore di startTime...
                // Controlla se currentTime è minore di endTime
                if (currentTimeComponents.hour! < endTimeComponents.hour!) || ((currentTimeComponents.hour! == endTimeComponents.hour!) && (currentTimeComponents.minute! <= endTimeComponents.minute!)) {
                    // Se currentTime è < di startTime e <= di endTime, è nell'intervallo
                    return true
                } else {
                    // Se currentTime è < di startTime ma > di endTime, non è nell'intervallo
                    return false
                }
            }
        } else {
            // 2) Se startTime è minore/uguale a endTime...
            // Controlla se currentTime è maggiore di startTime
            if (currentTimeComponents.hour! > startTimeComponents.hour!) || ((currentTimeComponents.hour! == startTimeComponents.hour!) && (currentTimeComponents.minute! >= startTimeComponents.minute!)) {
                // Se currentTime è maggiore di startTime...
                // Controlla se currentTime è minore di endTime
                if (currentTimeComponents.hour! < endTimeComponents.hour!) || ((currentTimeComponents.hour! == endTimeComponents.hour!) && (currentTimeComponents.minute! <= endTimeComponents.minute!)) {
                    // Se currentTime è >= di startTime e <= di endTime, è nell'intervallo
                    return true
                } else {
                    // Se currentTime è >= di startTime ma > di endTime, non è nell'intervallo
                    return false
                }
            } else {
                // Se currentTime è minore di startTime, non è nell'intervallo
                return false
            }
        }
    }
    
    // Funzione per controllare di quanto aumentare la salute in base ai passi
    func increaseCompletionPercentage() {
        
        let stepCalc = StatsManager.calcNewStepStat()
        let stepCalcWithGoal = max((Double(stepCalc) / Double(stepGoal)), 0.0)
        
        if (completionPercentage + stepCalcWithGoal) > 1.0 {
            completionPercentage = 1.0
        } else {
            completionPercentage += stepCalcWithGoal
        }
        
        print("--- Step Increment Check:")
        print("step calculation = ", stepCalc)
        print("step goal = ", Double(stepGoal))
        print("increase = ", stepCalcWithGoal)
        print("health percentage = ", completionPercentage)
    }
    
    // Funzione per controllare di quanto decrementare la salute in base ai secondi
    func updateCompletionPercentage() {
        var dateDifference: DateComponents = DateComponents()
        let currentDate = Date()
        
        if let formerDate = UserDefaults.standard.object(forKey: "formerInactiveHealth") as? Date {
            
            // Estrae le componenti tra le due date di accesso
            dateDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: formerDate, to: currentDate)
            
            let daysPassed = dateDifference.day ?? 0
            let hoursPassed = dateDifference.hour ?? 0
            let minutesPassed = dateDifference.minute ?? 0
            let secondsPassed = dateDifference.second ?? 0
            
            // Converte i giorni, le ore e i minuti in secondi
            let daysPassedInSec = daysPassed * 86400
            let hoursPassedInSec = hoursPassed * 3600
            let minutesPassedInSec = minutesPassed * 60
            
            // Calcola la differenza (in secondi) delle ore di sonne
            var sleepSeconds: Double = 0
            if startTime > endTime {
                sleepSeconds = startTime.timeIntervalSince(endTime)
                sleepSeconds = sleepSeconds / 2
            } else {
                sleepSeconds = endTime.timeIntervalSince(startTime)
            }
            
            // Estraggo le componenti delle date per effettuare confronti
            let formerTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: formerDate)
            let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
            let currentTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: currentDate)
            let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)

            let formerTime = Calendar.current.date(from: formerTimeComponents)!
            let startSleepTime = Calendar.current.date(from: startTimeComponents)!
            let currentTime = Calendar.current.date(from: currentTimeComponents)!
            let endSleepTime = Calendar.current.date(from: endTimeComponents)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            print("--- Health Deacrease Progress Check:")
            print("startSleepTime: ", dateFormatter.string(from: startTime))
            print("endSleepTime: ", dateFormatter.string(from: endTime))
            print("formerTime: ", dateFormatter.string(from: formerTime))
            print("currentTime: ", dateFormatter.string(from: currentTime))
            
            // Calcola il numero di secondi di sonno totali
            var totalSleepSeconds: Double = 0
            if startTime > endTime {
                if formerTime > currentTime {
                    totalSleepSeconds = sleepSeconds
                    if daysPassed > 0 {
                        totalSleepSeconds += sleepSeconds * Double(daysPassed)
                    }
                } else {
                    if daysPassed > 0 {
                        totalSleepSeconds = sleepSeconds * Double(daysPassed)
                    }
                }
            } else {
                if formerTime > currentTime {
                    if currentTime < startSleepTime {
                        if daysPassed > 0 {
                            totalSleepSeconds = sleepSeconds * Double(daysPassed)
                        }
                    } else if currentTime > endSleepTime {
                        totalSleepSeconds = sleepSeconds
                        if daysPassed > 0 {
                            totalSleepSeconds += sleepSeconds * Double(daysPassed)
                        }
                    }
                } else if formerTime == currentTime {
                    if daysPassed > 0 {
                        totalSleepSeconds = sleepSeconds * Double(daysPassed)
                    }
                } else {
                    if formerTime < startSleepTime && currentTime > endSleepTime {
                        totalSleepSeconds = sleepSeconds
                        if daysPassed > 0 {
                            totalSleepSeconds += sleepSeconds * Double(daysPassed)
                        }
                    }
                }
            }
            
            // Calcola il tempo passato tra le due date (in secondi)
            let totalPassedSeconds = Double(daysPassedInSec + hoursPassedInSec + minutesPassedInSec + secondsPassed)
            
            // Calcola il tempo passato tra le due date (in secondi) escludendo i secondi di sonno
            let secondsPassedWithoutSleep = max(totalPassedSeconds - totalSleepSeconds, 0)
            
            // In base alla difficoltà, viene assegnato un fattore costante (ad esempio: 0.000008, 0.00002)
            var multiplier: Double
            if difficulty == .normal {
                multiplier = 0.000008
            } else {
                multiplier = 0.00002
            }
            // Moltiplica il tempo trascorso per un fattore costante
            let progressDecreasePercentage = secondsPassedWithoutSleep * multiplier
            
            if (completionPercentage - progressDecreasePercentage) < 0.0 {
                completionPercentage = 0.0
            } else {
                completionPercentage -= progressDecreasePercentage
            }
            
            print("--- Health Decrease Progress Check:")
            print("days passed =", daysPassed)
            print("hours passed =", hoursPassed)
            print("minutes passed =", minutesPassed)
            print("seconds passed =", secondsPassed)
            print("sleep seconds =", totalSleepSeconds)
            print("seconds passed without sleep =", secondsPassedWithoutSleep)
            print("progress decrease =", progressDecreasePercentage)
            print("multiplier =", multiplier)
            print("health percentage =", completionPercentage)
            
            // Aggiorna la data di ultimo accesso in modo da non incrementare la variabile ad ogni chiamata di funzione
            UserDefaults.standard.set(Date(), forKey: "formerInactiveHealth")
            
        } else {
            // Aggiorna la data di ultimo accesso
            UserDefaults.standard.set(Date(), forKey: "formerInactiveHealth")
            
            return
        }
    }
    
    // Funzione per controllare di quanto decrementare i progressi del razzo in base ai secondi
    func updateRocketProgress() {
        var dateDifference: DateComponents = DateComponents()
        let currentDate = Date()
        
        if let formerDate = UserDefaults.standard.object(forKey: "formerInactiveRocket") as? Date {
            
            // Estrae le componenti tra le due date di accesso
            dateDifference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: formerDate, to: currentDate)
            
            let daysPassed = dateDifference.day ?? 0
            let hoursPassed = dateDifference.hour ?? 0
            let minutesPassed = dateDifference.minute ?? 0
            let secondsPassed = dateDifference.second ?? 0
            
            // Converte i giorni, le ore e i minuti in secondi
            let daysPassedInSec = daysPassed * 86400
            let hoursPassedInSec = hoursPassed * 3600
            let minutesPassedInSec = minutesPassed * 60
            
            // Calcola la differenza (in secondi) delle ore di sonne
            var sleepSeconds: Double = 0
            if startTime > endTime {
                sleepSeconds = startTime.timeIntervalSince(endTime)
                sleepSeconds = sleepSeconds / 2
            } else {
                sleepSeconds = endTime.timeIntervalSince(startTime)
            }
            
            // Estraggo le componenti delle date per effettuare confronti
            let formerTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: formerDate)
            let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
            let currentTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: currentDate)
            let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)

            let formerTime = Calendar.current.date(from: formerTimeComponents)!
            let startSleepTime = Calendar.current.date(from: startTimeComponents)!
            let currentTime = Calendar.current.date(from: currentTimeComponents)!
            let endSleepTime = Calendar.current.date(from: endTimeComponents)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            print("--- Health Deacrease Progress Check:")
            print("startSleepTime: ", dateFormatter.string(from: startTime))
            print("endSleepTime: ", dateFormatter.string(from: endTime))
            print("formerTime: ", dateFormatter.string(from: formerTime))
            print("currentTime: ", dateFormatter.string(from: currentTime))
            
            // Calcola il numero di secondi di sonno totali
            var totalSleepSeconds: Double = 0
            if startTime > endTime {
                if formerTime > currentTime {
                    totalSleepSeconds = sleepSeconds
                    if daysPassed > 0 {
                        totalSleepSeconds += sleepSeconds * Double(daysPassed)
                    }
                } else {
                    if daysPassed > 0 {
                        totalSleepSeconds = sleepSeconds * Double(daysPassed)
                    }
                }
            } else {
                if formerTime > currentTime {
                    if currentTime < startSleepTime {
                        if daysPassed > 0 {
                            totalSleepSeconds = sleepSeconds * Double(daysPassed)
                        }
                    } else if currentTime > endSleepTime {
                        totalSleepSeconds = sleepSeconds
                        if daysPassed > 0 {
                            totalSleepSeconds += sleepSeconds * Double(daysPassed)
                        }
                    }
                } else if formerTime == currentTime {
                    if daysPassed > 0 {
                        totalSleepSeconds = sleepSeconds * Double(daysPassed)
                    }
                } else {
                    if formerTime < startSleepTime && currentTime > endSleepTime {
                        totalSleepSeconds = sleepSeconds
                        if daysPassed > 0 {
                            totalSleepSeconds += sleepSeconds * Double(daysPassed)
                        }
                    }
                }
            }
            
            // Calcola il tempo passato tra le due date (in secondi)
            let totalPassedSeconds = Double(daysPassedInSec + hoursPassedInSec + minutesPassedInSec + secondsPassed)
            
            // Calcola il tempo passato tra le due date (in secondi) escludendo i secondi di sonno
            let secondsPassedWithoutSleep = max(totalPassedSeconds - totalSleepSeconds, 0)
            
            // Moltiplica il tempo trascorso per un fattore costante (ad esempio: 0.0005, 0.0002 per testare)
            let progressIncreasePercentage = secondsPassedWithoutSleep * 0.0002
            
            if (rocketProgress + progressIncreasePercentage) > 100 {
                rocketProgress = 100
            } else {
                rocketProgress += progressIncreasePercentage
            }
            
            print("--- Rocket Progress Check:")
            print("days passed =", daysPassed)
            print("hours passed =", hoursPassed)
            print("minutes passed =", minutesPassed)
            print("seconds passed =", secondsPassed)
            print("sleep seconds =", sleepSeconds)
            print("seconds passed without sleep =", secondsPassedWithoutSleep)
            print("progress increase =", progressIncreasePercentage)
            print("rocket progress =", rocketProgress)
            
            // Aggiorna la data di ultimo accesso in modo da non incrementare la variabile ad ogni chiamata di funzione
            UserDefaults.standard.set(Date(), forKey: "formerInactiveRocket")
            
        } else {
            // Aggiorna la data di ultimo accesso
            UserDefaults.standard.set(Date(), forKey: "formerInactiveRocket")
            
            return
        }
    }
    
}
