//
//  HealthManager.swift
//  Fitgotchi
//
//  Created by Davide Perrotta on 20/02/24.
//

import Foundation
import SwiftUI
import Combine
import HealthKit
import WatchKit


class HealthManager: ObservableObject {
    
    //@State public var timerStarted : Bool = false
    
    let healthStore = HKHealthStore()
    var fiTagotchiData: FiTagotchiData!
    
    
    init(points: Int, heartRate: Int, flightsClimbed: Int, burnedCalories: Int, minutesExercise: Int, totalScore: Int)
    {
        self.points = points
        self.heartRate = heartRate
        self.flightsClimbed = flightsClimbed
        self.burnedCalories = burnedCalories
        self.minutesExercise = minutesExercise
        self.totalScore = totalScore
    }
    
    private var timer : Timer = Timer()
    private var timer2 : Timer = Timer()
    @AppStorage("punteggio") public var points : Int = 0
    
    @Published public var stepCount: Int = 0
    @Published public var heartRate: Int = 0
    @Published public var flightsClimbed: Int = 0
    @Published public var burnedCalories: Int = 0
    @Published public var minutesExercise: Int = 0
    @Published public var distanceWalkingRunning: Int = 0
    @Published public var currentStepCount: Int = 0
    
    @Published var totalScore: Int = 0
    
    @State private var isDailyGoalAccomplished : Bool = false
    @State var stepGoal : Int = 0
    
    func setEnvFitData(fiTagotchiData: FiTagotchiData) {
        self.fiTagotchiData = fiTagotchiData
    }
    
    func auth(){
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let active_Energy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let resting_Heart_Rate = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let flights_Climbed = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let exercise_Minutes = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        let stand_Minutes = HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
        let walking_Heart_Rate_Average = HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage)!
        let highHeartRateEvent = HKCategoryType.categoryType(forIdentifier: .highHeartRateEvent)!
        let distanceWalkingRunning = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
         
        let healthTypes: Set<HKObjectType> = [steps, heartRate, active_Energy, resting_Heart_Rate, flights_Climbed, exercise_Minutes, stand_Minutes, walking_Heart_Rate_Average, highHeartRateEvent, distanceWalkingRunning ]
        
        let typesToShare: Set<HKSampleType> = []
          
        self.healthStore.requestAuthorization(toShare: typesToShare, read: healthTypes) { success, error in
            if success {
                print("La richiesta di autorizzazione ad HealthKit è stata accettata.")
            } else {
                print("Errore durante la richiesta di autorizzazione a HealthKit: \(String(describing: error?.localizedDescription))")
            }
        }
        
        //AUTORIZZAZIONE A RECUPERARE I DATI DEL BATTITO CARDIACO IN BACKGROUND
        self.healthStore.enableBackgroundDelivery(for: heartRate, frequency: .immediate){ success, error  in
            if success
            {
                print("Consegna in background abilitata per i dati del battito cardiaco")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati del battito cardiaco: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        //AUTORIZZAZIONE A RECUPERARE I DATI DEI PASSI IN BACKGROUND
        self.healthStore.enableBackgroundDelivery(for: steps, frequency: .immediate){ success, error in
            if success
            {
                print("Consegna in background abilitata per i dati del conta passi")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati del conta passi: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        //AUTORIZZAZIONE A RECUPERARE I DATI DEI PIANI SALITI IN BACKGROUND
        self.healthStore.enableBackgroundDelivery(for: flights_Climbed, frequency: .immediate){ success, error in
            if success
            {
                print("Consegna in background abilitata per i dati dei piani saliti")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati dei piani saliti: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        //AUTORIZZAZIONE A RECUPERARE I DATI DEI PIANI SALITI IN BACKGROUND
        self.healthStore.enableBackgroundDelivery(for: active_Energy, frequency: .immediate){ success, error in
            if success
            {
                print("Consegna in background abilitata per i dati del conta calorie bruciate")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati delle calorie bruciate: \(error?.localizedDescription ?? "Unknown error")")
            }
        }

        //AUTORIZZAZIONE A RECUPERARE I DATI DEI MINUTI DI ESERCIZIO IN BACKGROUND
        self.healthStore.enableBackgroundDelivery(for: exercise_Minutes, frequency: .immediate) { success, error in
            if success
            {
                print("Consegna in background abilitata per i dati dei minuti di esercizio compiuti")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati di esercizio compiuti: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        self.healthStore.enableBackgroundDelivery(for: distanceWalkingRunning, frequency: .immediate){ success, error in
            if success
            {
                print("Consegna in background abilitata per i dati di distanza camminata/corsa")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati di distanza camminata/corsa: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        self.healthStore.enableBackgroundDelivery(for: stand_Minutes, frequency: .immediate) { success, error in
                if success {
                    print("Consegna in background abilitata per i dati dei minuti in cui hai fatto stazione")
                } else {
                    print("Errore durante l'abilitazione della consegna in background per i dati dei minuti in cui hai fatto stazione: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        
        self.healthStore.enableBackgroundDelivery(for: resting_Heart_Rate, frequency: .immediate){ success, error in
            if success
            {
                print("Consegna in background abilitata per i dati di distanza camminata/corsa")
            }
            else
            {
                print("Errore durante l'abilitazione della consegna in background per i dati di resting_Heart_Rate: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func startTimer() {
        timer2 = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            self.fetchData()
        }
    }

    func fetchData() {
        self.getStepCount { count in
            self.currentStepCount = count
                self.retrieveFlightsClimbed { flightsClimbed in
                    self.readTodaysActiveEnergyBurned { active_Energy in
                        self.minuteExercise{ exercise_Minutes in
                            self.retrieveHeartRate{ heartRate in
                                self.checkStepGoal{ steps in
                                    self.DistanceWalkingRunning{ distanceWalkingRunning in
                                        self.retrieveStandMinutes { stand_Minutes in
                                            self.fetchRestingHeartRateData { resting_Heart_Rate in
                                                self.stepGoal = UserDefaults.standard.integer(forKey: "dailyStepGoal")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func fetchRestingHeartRateData(completion: @escaping (Int?) -> Void) {
        let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
        let query = HKSampleQuery(sampleType: restingHeartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples as? [HKQuantitySample], let quantity = samples.last?.quantity else {
                if let error = error {
                    print("Error fetching resting heart rate data: \(error.localizedDescription)")
                }
                // No data available for resting heart rate, return nil
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
                
            let beatsPerMinute = quantity.doubleValue(for: HKUnit(from: "count/min"))
            print("Frequenza cardiaca a riposo: \(Int(beatsPerMinute))")
            
            DispatchQueue.main.async {
                // Handle resting heart rate data
                completion(Int(beatsPerMinute))
            }
        }
            
        healthStore.execute(query)
    }

    func DistanceWalkingRunning(completion: @escaping (Int) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startOfDay, intervalComponents: DateComponents(day: 1))
        
        query.initialResultsHandler = { query, results, error in
            guard let results = results else {
                if let error = error {
                    print("Errore durante il recupero dei dati sulla distanza camminata/corsa: \(error.localizedDescription)")
                }
                return
            }
            
            results.enumerateStatistics(from: startOfDay, to: now) { statistics, stop in
                if let sum = statistics.sumQuantity() {
                    let distanceInKilometers = sum.doubleValue(for: HKUnit.meterUnit(with: .kilo))
                    print("Distanza camminata/corsa: \(Int(distanceInKilometers)) km")
                    DispatchQueue.main.async {
                        completion(Int(distanceInKilometers))
                    }
                }
            }
        }
        healthStore.execute(query)
    }


    

    func checkStepGoal(completion: @escaping (Int) -> Void)
    {
        // Calcola l'intervallo di tempo per il quale verificare il raggiungimento dell'obiettivo
        let calendar = Calendar.current
        // Usare 'now' per indicare la data corrente
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: now)!
        // Crea un predicato per ottenere i campioni dei passi di oggi
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        // Crea una query per ottenere i campioni dei passi di oggi
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!, quantitySamplePredicate: predicate, options: .cumulativeSum)
        { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Errore durante il recupero dei dati sui passi: \(error?.localizedDescription ?? "Errore sconosciuto")")
                return
            }
            // Ottieni il numero di passi eseguiti oggi
            let stepsToday = sum.doubleValue(for: HKUnit.count())
            print("Steps Nella settimana = \(Int(stepsToday))")
            // Controlla se il numero di passi eseguiti oggi ha raggiunto l'obiettivo
            if !self.isDailyGoalAccomplished{
                if Int(stepsToday) >= self.stepGoal {
                    print("Hai raggiunto l'obiettivo di \(self.stepGoal) passi oggi!")
                    self.points += 100
                    self.isDailyGoalAccomplished = true
                } else {
                    print("Ancora \(self.stepGoal - Int(stepsToday)) passi per raggiungere l'obiettivo di \(self.stepGoal) passi oggi.")
                }
            }
        }

        // Esegui la query
        healthStore.execute(query)
    }

    //FUNCTION CONTA PASSI (NON IN TEMPO REALE)
    func getStepCount(completion: @escaping (Int) -> Void) {
        let healthStore = HKHealthStore() // Inizializza HKHealthStore direttamente

        if !HKHealthStore.isHealthDataAvailable() {
            print("Health store is not available.")
            completion(0) // Return default value if health store is not available
            return
        }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        self.checkAndResetStepCountIfNeeded()
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            if let error = error {
                print("Error retrieving step count data: \(error.localizedDescription)")
                completion(0) // Return default value if there's an error
                return
            }

            guard let result = result, let sum = result.sumQuantity() else {
                print("No data available for step count.")
                completion(0) // Return default value if there's no data
                return
            }

            DispatchQueue.main.async {
                let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                // Salvataggio del valore di stepCount nelle UserDefaults di FiTagotchi
                UserDefaults.standard.set(stepCount, forKey: UserDefaultsKeys.stepCount)
                completion(stepCount)
            }
        }

        healthStore.execute(query)
    }
    
//    FUNCTION PER VERIFICARE SE È PASSATA LA GIORNATA, SE SI SETTA A 0 NELLO USERDEFAULTS
    func checkAndResetStepCountIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        if let savedDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.dateLastStepCountReset) as? Date {
            if calendar.isDate(now, inSameDayAs: savedDate) {
                // È lo stesso giorno, non è necessario azzerare lo step count
                return
            }
        }

        // Se si arriva qui, significa che è iniziato un nuovo giorno
        UserDefaults.standard.set(startOfDay, forKey: UserDefaultsKeys.dateLastStepCountReset)
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.stepCount)
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.lastAccessStepCount)
        UserDefaults.standard.synchronize()
    }


    //FUNCTION CONTA BATTITO CARDIACO (NON IN TEMPO REALE)
    func retrieveHeartRate(completion: @escaping (Int) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Errore nel recupero dei dati per il battito cardiaco: \(error.localizedDescription)")
                    return
                }

                if let heartRateSamples = samples, let quantitySample = heartRateSamples.first as? HKQuantitySample {
                    let heartRate = quantitySample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    let date = quantitySample.endDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone.current
                    let currentDateInLocalTimezone = dateFormatter.string(from: date)
                    self.heartRate = Int(heartRate)
                    print("Battito cardiaco: \(heartRate) bpm, Data: \(currentDateInLocalTimezone)")
                } else {
                    // Se non ci sono dati disponibili per il giorno corrente, recuperiamo i dati del giorno precedente
                    //                    self.retrieveLastHeartRate()
                }
            }
        }

        healthStore.execute(query)
    }
    
    func retrieveFlightsClimbed(completion: @escaping (Int) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: .flightsClimbed)!, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Errore durante il recupero dei dati sui piani saliti: \(error.localizedDescription)")
                }
                return
            }

            DispatchQueue.main.async {
                let flightsClimbed = Int(sum.doubleValue(for: HKUnit.count()))
                print("Piani saliti = \(flightsClimbed)")
                completion(flightsClimbed)
            }
        }

        healthStore.execute(query)
    }

    //FUNCTION CONTA CALORIE BRUCIATE (NON IN TEMPO REALE)
    func readTodaysActiveEnergyBurned(completion: @escaping (Int) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { (query, result, error) in
            guard let result = result else {
                print("Errore durante il recupero dei dati sulla quantità di calorie bruciate oggi: \(error?.localizedDescription ?? "Errore sconosciuto")")
                return
            }
            
            if let sum = result.sumQuantity() {
                let kilocalories = sum.doubleValue(for: HKUnit.kilocalorie())
                let caloriesBurned = Int(kilocalories)
                print("Calorie bruciate oggi: \(caloriesBurned) kcal")
                DispatchQueue.main.async {
                    completion(caloriesBurned)
                }
            } else {
                print("Nessun dato disponibile sulle calorie bruciate oggi.")
            }
        }
        
        healthStore.execute(query)
    }

    //FUNCTION MINUTI DI ESERCIZIO GIORNALIERO
    func minuteExercise(completion: @escaping (Int) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Errore durante il recupero dei dati sui minuti di esercizio oggi: \(error.localizedDescription)")
                    return
                }
                
                guard let result = result else {
                    print("Nessun risultato disponibile per i minuti di esercizio oggi.")
                    return
                }
                
                if let sum = result.sumQuantity() {
                    let minutesExercise = sum.doubleValue(for: HKUnit.minute())
                    self.minutesExercise = Int(minutesExercise)
                }
            }
        }
        
        // Esegui la query
        healthStore.execute(query)
    }
    
    func retrieveStandMinutes(completion: @escaping (Int) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Errore durante il recupero dei dati sui minuti in cui hai fatto stazione oggi: \(error.localizedDescription)")
                    return
                }
                
                guard let result = result else {
                    print("Nessun risultato disponibile per i minuti in cui hai fatto stazione oggi.")
                    return
                }
                
                if let sum = result.sumQuantity() {
                    let standMinutes = sum.doubleValue(for: HKUnit.minute())
                    completion(Int(standMinutes))
                }
            }
        }
        
        // Esegui la query
        healthStore.execute(query)
    }
}
