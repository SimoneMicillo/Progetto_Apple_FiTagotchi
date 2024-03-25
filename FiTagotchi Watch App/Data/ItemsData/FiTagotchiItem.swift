//
//  FiTagotchiItem.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 21/02/24.
//

import Foundation
import SwiftUI

struct Item: Identifiable, Codable {
    var id = UUID()
    var name: String
    var image: String
    var cost: Int
    var purpose: String
    var value: Double
}
