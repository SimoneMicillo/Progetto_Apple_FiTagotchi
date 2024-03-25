//
//  DifficultySelectionView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 21/02/24.
//

import SwiftUI

struct DifficultySelectionView: View {
    @ObservedObject var fiTagotchiData: FiTagotchiData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Picker("", selection: $fiTagotchiData.difficulty) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.bottom)
            Text("The level of difficulty affects how quickly your creature’s health decreases.")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
}


struct DifficultySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let fiTagotchiData = FiTagotchiData()
        DifficultySelectionView(fiTagotchiData: fiTagotchiData)
    }
}

