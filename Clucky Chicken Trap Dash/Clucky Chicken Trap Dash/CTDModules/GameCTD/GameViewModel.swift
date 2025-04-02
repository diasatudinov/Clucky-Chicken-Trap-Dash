import Combine

class GameViewModel: ObservableObject {
    @Published var heroHealth: Int = 100
    @Published var heroMaxHealth: Int = 100
    @Published var enemyHealth: Int = 100
    @Published var enemyMaxHealth: Int = 100
    
    // Статистика игры
    @Published var distanceTraveled: CGFloat = 0
    @Published var totalEnemiesKilled: Int = 0
    @Published var totalTime: TimeInterval = 0
    @Published var healthLost: Int = 0
    @Published var totalDamageDealt: Int = 0
    @Published var accumulatedDamageTaken: Int = 0
    @Published var pepperUsage: Int = 0
    
    // Флаг завершения игры
    @Published var gameEnded: Bool = false
}
