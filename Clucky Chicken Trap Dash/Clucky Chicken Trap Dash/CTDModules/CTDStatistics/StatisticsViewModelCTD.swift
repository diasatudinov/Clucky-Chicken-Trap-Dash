import SwiftUI

class StatisticsViewModelCTD: ObservableObject {
    
    @AppStorage("totalEnemiesKilled") var monstersKilled: Int = 0
    @AppStorage("defeatedBosses") var defeatedBosses: Int = 0
    @AppStorage("maxHeroLevel") var maxHeroLevel: Int = 0
    @AppStorage("goldAccumulated") var goldAccumulated: Int = 0
    @AppStorage("goldSpent") var goldSpent: Int = 0
    @AppStorage("matchesPlayed") var matchesPlayed: Int = 0
    @AppStorage("totalTime") var totalTime: TimeInterval = 0
    
}

