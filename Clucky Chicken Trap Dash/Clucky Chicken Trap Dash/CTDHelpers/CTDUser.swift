//
//  SLUser.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 02.04.2025.
//


import SwiftUI

class CTDUser: ObservableObject {
    
    static let shared = CTDUser()
    
    @AppStorage("money") var storedMoney: Int = 3000
    @Published var money: Int = 3000
    
    init() {
        money = storedMoney
    }
    
    
    func updateUserBirds(for coins: Int) {
        self.money += coins
        storedMoney = self.money
    }
    
    func minusUserBirds(for money: Int) {
        self.money -= money
        if self.money < 0 {
            self.money = 0
        }
        storedMoney = self.money
        
    }
    
}
