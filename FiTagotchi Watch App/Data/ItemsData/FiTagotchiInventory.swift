//
//  FiTagotchiItemDisplay.swift
//  FiTagotchi Watch App
//
//  Created by Alessandro on 23/02/24.
//

import Foundation

class InventoryItem: Identifiable, ObservableObject, Codable {
    var id: UUID
    @Published var item: Item
    @Published var quantity: Int

    init(id: UUID, item: Item, quantity: Int) {
        self.id = id
        self.item = item
        self.quantity = quantity
    }

    // Conformità ai protocolli Decodable e Encodable
    enum CodingKeys: String, CodingKey {
        case id
        case item
        case quantity
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        item = try container.decode(Item.self, forKey: .item)
        quantity = try container.decode(Int.self, forKey: .quantity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(item, forKey: .item)
        try container.encode(quantity, forKey: .quantity)
    }
}

class Inventory: ObservableObject {
    @Published var items: [InventoryItem] = []
    
    func addItem(name: String, image: String, cost: Int, purpose: String, value: Double, quantity: Int) {
        let newItem = Item(name: name, image: image, cost: cost, purpose: purpose, value: value)
        let newInventoryItem = InventoryItem(id: UUID(), item: newItem, quantity: quantity)
        items.append(newInventoryItem)
        saveInventory()
    }
    
    @discardableResult
    func purchaseItem(_ item: Item) -> Bool {
        guard let inventoryItem = items.first(where: { $0.item.name == item.name }) else {
            // Se l'oggetto non è presente, aggiungilo all'inventario
            addItem(name: item.name, image: item.image, cost: item.cost, purpose: item.purpose, value: item.value, quantity: 1)
            return true  // Acquisto avvenuto con successo
        }
        
        // Se l'oggetto è già presente, incrementa la quantità
        inventoryItem.quantity += 1
        saveInventory()
        return true  // Acquisto avvenuto con successo
    }
    
    func consumeItem(_ inventoryItem: InventoryItem) {
        guard let index = items.firstIndex(where: { $0.id == inventoryItem.id }) else {
            // L'oggetto non è presente nell'inventario
            return
        }

        // Decrementa la quantità e rimuovi l'oggetto se la quantità è zero
        items[index].quantity -= 1
        if items[index].quantity == 0 {
            items.remove(at: index)
        }

        saveInventory()
    }
    
    func saveInventory() {
        // Implementa la logica per salvare l'inventario nell'archiviazione persistente (ad esempio, UserDefaults)
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(items)
            UserDefaults.standard.set(encoded, forKey: "inventoryItems")
        } catch {
            print("Error encoding inventoryItems: \(error)")
        }
    }

    func loadInventory() {
        // Implementa la logica per caricare l'inventario dall'archiviazione persistente (ad esempio, UserDefaults)
        if let data = UserDefaults.standard.data(forKey: "inventoryItems") {
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode([InventoryItem].self, from: data)
                items = decoded
            } catch {
                print("Error decoding inventoryItems: \(error)")
            }
        }
    }
}
