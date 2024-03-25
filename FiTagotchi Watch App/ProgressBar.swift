//
//  ProgressBar.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 04/03/24.
//

import SwiftUI

struct ProgressBar: View {
    var width: Double
    var height: Double
    var color1 = Color(.yellow)
    var color2 = Color(.green)
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    var body: some View {
        GeometryReader { geometry in
            let multiplier =  geometry.size.width / 100
            ZStack(alignment: .leading) {
                // Barra del contenitore (scura)
                RoundedRectangle(cornerRadius: height, style: .continuous)
                    .frame(width: 100.0 * multiplier, height: height)
                    .foregroundColor(Color.black.opacity(0.2))
                
                // Barra del progresso (colorata)
                RoundedRectangle(cornerRadius: height, style: .continuous)
                    .frame(width: fiTagotchiData.rocketProgress * multiplier, height: height)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous))
                    )
                    .foregroundColor(.clear)
            }
        }
        .padding()
    }
}

#Preview {
    ProgressBar(width: 300, height: 20)
}
