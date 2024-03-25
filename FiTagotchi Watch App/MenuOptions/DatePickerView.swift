//
//  DatePickerView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 19/02/24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    var title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DatePicker("\(title)", selection: $selectedDate, displayedComponents: .hourAndMinute)
                //.labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
            if title == "Bedtime" {
                Text("During sleep hours, its health value will not decrease, and the rocket process will pause.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            } else if title == "Wake up time" {
                Text("When your creature awakens, it will resume consuming health and increasing rocket progress.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()), title: "Bedtime")
}
