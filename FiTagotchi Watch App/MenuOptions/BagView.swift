//
//  ItemsView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 23/02/24.
//

import SwiftUI

struct BagView: View {
    @ObservedObject var inventory: Inventory
    @State private var isAlertPresented = false
    @State private var selectedItem: InventoryItem?
    
    var statistic: StatisticCircleView
    
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    
    var body: some View {
        if inventory.items.isEmpty {
            // Mostra un messaggio informativo se l'inventario è vuoto
            Text("In the bag, you can see the food purchased from the 'Food' section.")
                .padding()
                .multilineTextAlignment(.center) // Allinea il testo al centro
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
                .navigationBarTitle("Bag")
                .onAppear {
                    // Carica l'inventario quando la vista appare
                    inventory.loadInventory()
                }
        } else {
            List {
                ForEach(inventory.items) { inventoryItem in
                    HStack {
                        Image(String(inventoryItem.item.image))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text(inventoryItem.item.name)
                                .font(.headline)
                            Text("\(Image(systemName: "heart.fill")) \(inventoryItem.item.purpose)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Qty: \(inventoryItem.quantity)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Setta l'elemento selezionato prima di mostrare l'alert
                            selectedItem = inventoryItem
                            isAlertPresented = true
                        }) {
                            Image(systemName: "hand.draw.fill")
                        }
                        .padding()
                        .background(Color(red: 0.220, green: 0.200, blue: 0.530))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Bag")
            .onAppear {
                // Carica l'inventario quando la vista appare
                inventory.loadInventory()
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(
                    title: Text("Consume Food"),
                    message: Text("Are you sure you want to consume \(selectedItem?.item.name ?? "")?"),
                    primaryButton: .default(Text("Confirm")) {
                        if let selectedItem = selectedItem {
                            consumeItem(selectedItem)
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel")) {
                        // Chiudi l'alert
                        isAlertPresented = false
                    }
                )
            }
        }
    }
    
    func consumeItem(_ item: InventoryItem) {
        // Logica per il consumo dell'oggetto
        inventory.consumeItem(item)
        inventory.saveInventory()
        
        if (fiTagotchiData.completionPercentage + item.item.value) > 1.0 {
            fiTagotchiData.completionPercentage = 1.0
        } else {
            fiTagotchiData.completionPercentage += item.item.value
        }
    }

}
