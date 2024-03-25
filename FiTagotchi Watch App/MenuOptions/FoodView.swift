//
//  ShopView.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 21/02/24.
//

import SwiftUI

struct FoodView: View {
    @EnvironmentObject var fiTagotchiData: FiTagotchiData
    @ObservedObject var inventory: Inventory
    @State private var selectedItem: Item?
    @State private var showingAlert = false
    @State private var notEnoughCoins = false
    @State private var alertType: AlertType?
    
    enum AlertType: Identifiable {
        case buyConfirmation, notEnoughCoins
        
        var id: Int {
            switch self {
            case .buyConfirmation:
                return 0
            case .notEnoughCoins:
                return 1
            }
        }
    }

    var shopItems: [Item] = [
        Item(name: "Lollipop", image: "lollipop_item", cost: 10, purpose: "5%", value: 0.05),
        Item(name: "Chicken", image: "chicken_item", cost: 25, purpose: "20%", value: 0.2),
        // Qui si possono aggiungere altri oggetti
    ]

    var body: some View {
        
        VStack {
            HStack {
                    Spacer()
                    
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(fiTagotchiData.actualCoins)")
                        .padding(.trailing)
                    }
            List {
                ForEach(shopItems) { item in
                    HStack {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text("\(Image(systemName: "heart.fill")) \(item.purpose)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("\(item.cost)")
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                        Button("\(Image(systemName: "basket.fill"))") {
                            selectedItem = item
                            if fiTagotchiData.actualCoins >= selectedItem!.cost {
                                notEnoughCoins = false
                                alertType = .buyConfirmation
                            } else {
                                notEnoughCoins = true
                                alertType = .notEnoughCoins
                            }
                        }
                        .padding()
                        .background(Color(red: 0.220, green: 0.200, blue: 0.530))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                Text("Coins to buy food can be obtained by completing the challenges in the 'Missions' section.")
                    .font(.footnote)
                    .listRowBackground(Color.clear)
                    .foregroundStyle(.gray)
                Text("The purchased food will be available in the 'Bag' section.")
                    .font(.footnote)
                    .listRowBackground(Color.clear)
                    .foregroundStyle(.gray)
            }
        }
        .navigationBarTitle("Food")
        .alert(item: $alertType) { alertType in
            switch alertType {
            case .buyConfirmation:
                return Alert(
                    title: Text("Confirm Purchase"),
                    message: Text("Do you really want to buy \(selectedItem?.name ?? "") for \(selectedItem?.cost ?? 0) coins?"),
                    primaryButton: .cancel(Text("Confirm")) {
                        confirmPurchase()
                        fiTagotchiData.actualCoins -= selectedItem?.cost ?? 0
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            case .notEnoughCoins:
                return Alert(
                    title: Text("Insufficient Funds"),
                    message: Text("You don't have enough coins for this purchase."),
                    dismissButton: .cancel(Text("Ok"))
                )
                
            }
        }

    }

    func confirmPurchase() {
        guard let item = selectedItem else { return }

        // Logica per l'acquisto
        if inventory.purchaseItem(item) {
            // Acquisto confermato, esegue le azioni necessarie
            inventory.saveInventory()
        } else {
            // Acquisto non riuscito, gestisce di conseguenza
            print("Acquisto non riuscito.")
        }
    }
}


struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        let inventory = Inventory()  // Crea un'istanza di Inventory come modello di dati di esempio

        return NavigationView {
            FoodView(inventory: inventory)
        }
    }
}
