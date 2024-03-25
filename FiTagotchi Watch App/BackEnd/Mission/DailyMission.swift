//
//  DailyMission.swift
//  FiTagotchi Watch App
//
//  Created by Simone Micillo on 06/03/24.
//

import Foundation

struct DailyMission : Identifiable, Codable{
    var id = UUID()
    var description : String
    var container : Int
    var reward : Int
    var goal : Int
    var type: String
    
    func saveSelectedMission()
    {
        UserDefaults.standard.set(self, forKey: "\(id)")
        print(id)
    }
}
