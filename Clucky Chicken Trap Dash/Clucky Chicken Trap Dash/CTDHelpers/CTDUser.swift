import SwiftUI

class CTDUser: ObservableObject {
    
    static let shared = CTDUser()
    
    @AppStorage("money") var storedMoney: Int = 25000
    @Published var money: Int = 25000
    
    init() {
        money = storedMoney
    }
    
    
    func updateUserMoney(for money: Int) {
        self.money += money
        storedMoney = self.money
    }
    
    func minusUserMoney(for money: Int) {
        self.money -= money
        if self.money < 0 {
            self.money = 0
        }
        storedMoney = self.money
        
    }
    
}
