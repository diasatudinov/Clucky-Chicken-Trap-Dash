import SwiftUI

class ShopViewModelCTD: ObservableObject {
    @Published var shopTeamItems: [Item] = [
        
        Item(name: "item1CTD", level: 1, maxLevel: 5, effect: 5, cost: 0, bought: true),
        Item(name: "item2CTD", level: 1, maxLevel: 5, effect: 2, cost: 0, bought: true),
        Item(name: "item3CTD", level: 1, maxLevel: 5, effect: 100, cost: 0, bought: true),
        Item(name: "item4CTD", level: 1, maxLevel: 3, effect: 5, cost: 500, bought: false),
        Item(name: "item5CTD", level: 1, maxLevel: 3, effect: 5, cost: 300, bought: false),
        Item(name: "item6CTD", level: 1, maxLevel: 1, effect: 5, cost: 2000, bought: false),
        
    ] {
        didSet {
            saveTeam()
        }
    }
    
    @Published var boughtItems: [String] = [
        "hero1",
    ] {
        didSet {
            saveBoughtItem()
        }
    }
    
    @AppStorage("currentTeamItem") var currentTeamItem: String = "hero1"
    
    init() {
        loadTeam()
        loadBoughtItem()
    }
    
    private let userDefaultsTeamKey = "saveCurrentItemImage"
    private let userDefaultsBoughtKey = "boughtItem"

    func buyItem(for item: Item) {
        guard let index = shopTeamItems.firstIndex(where: { $0.name == item.name }) else {
            return
        }
        
        if shopTeamItems[index].level < shopTeamItems[index].maxLevel {
            shopTeamItems[index].level += 1
            
            switch shopTeamItems[index].name {
            case "item1CTD":
                switch shopTeamItems[index].level {
                case 2:
                    shopTeamItems[index].cost += 50
                    shopTeamItems[index].effect += 5
                case 3:
                    shopTeamItems[index].cost += 50
                    shopTeamItems[index].effect += 5
                case 4:
                    shopTeamItems[index].cost += 150
                    shopTeamItems[index].effect += 5
                case 5:
                    shopTeamItems[index].cost += 250
                    shopTeamItems[index].effect += 10
                default:
                    print("fail")
                }
                
            case "item2CTD":
                switch shopTeamItems[index].level {
                case 2:
                    shopTeamItems[index].cost += 50
                    shopTeamItems[index].effect += 3
                case 3:
                    shopTeamItems[index].cost += 100
                    shopTeamItems[index].effect += 3
                case 4:
                    shopTeamItems[index].cost += 150
                    shopTeamItems[index].effect += 4
                case 5:
                    shopTeamItems[index].cost += 300
                    shopTeamItems[index].effect += 8
                default:
                    print("fail")
                }
            case "item3CTD":
                switch shopTeamItems[index].level {
                case 2:
                    shopTeamItems[index].cost += 100
                    shopTeamItems[index].effect += 50
                case 3:
                    shopTeamItems[index].cost += 150
                    shopTeamItems[index].effect += 50
                case 4:
                    shopTeamItems[index].cost += 150
                    shopTeamItems[index].effect += 100
                case 5:
                    shopTeamItems[index].cost += 500
                    shopTeamItems[index].effect += 200
                default:
                    print("fail")
                }
            case "item4CTD":
                switch shopTeamItems[index].level {
                case 2:
                    shopTeamItems[index].cost += 500
                case 3:
                    shopTeamItems[index].cost += 1000
                default:
                    print("fail")
                }
            case "item5CTD":
                switch shopTeamItems[index].level {
                case 2:
                    shopTeamItems[index].cost += 300
                case 3:
                    shopTeamItems[index].cost += 400
                default:
                    print("fail")
                }
            case "item6CTD":
                print("item6CTD")
                
            default: break
                //
            }
        }
        
        
        
        
    }
    
    func saveTeam() {
        if let encodedData = try? JSONEncoder().encode(shopTeamItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsTeamKey)
        }
        
    }
    
    func loadTeam() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsTeamKey),
           let loadedItem = try? JSONDecoder().decode([Item].self, from: savedData) {
            shopTeamItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
    func saveBoughtItem() {
        if let encodedData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBoughtKey)
        }
        
    }
    
    func loadBoughtItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedItem = try? JSONDecoder().decode([String].self, from: savedData) {
            boughtItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var level: Int
    var maxLevel: Int
    var effect: Int
    var cost: Int
    var bought: Bool
}
