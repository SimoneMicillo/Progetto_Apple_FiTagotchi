//
//  RenameView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 19/02/24.
//

import SwiftUI

struct RenameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fiTagotchiData: FiTagotchiData

    var body: some View {
        Section(content: {
            TextField("Enter name", text: $fiTagotchiData.name)
        }, header: {
            Text("Actual name:")
        }, footer: {
            Text("Tap the text field to rename your FiTagotchi.")
                .font(.footnote)
                .foregroundStyle(.gray)
        })
        .navigationBarTitle("Rename")
    }
}

struct RenameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RenameView()
        }
    }
}
