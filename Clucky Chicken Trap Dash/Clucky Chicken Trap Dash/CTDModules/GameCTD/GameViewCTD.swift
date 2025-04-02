import SwiftUI
import SpriteKit


// MARK: - SwiftUI интерфейс для отображения игры
struct GameViewCTD: View {
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject var shopVM = ShopViewModelCTD()
    @State private var scene = BattleScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var body: some View {
        ZStack {
            // Отображаем SKScene
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    // Передаем модель в сцену
                    scene.viewModel = gameViewModel
                    scene.shopViewModel = shopVM
                }
            
            // SwiftUI-оверлей с HP баром
            VStack {
                HStack {
                    HPBarView(title: "Hero HP",
                              current: gameViewModel.heroHealth,
                              max: gameViewModel.heroMaxHealth)
                    .padding()
                    Spacer()
                    HPBarView(title: "Enemy HP",
                              current: gameViewModel.enemyHealth,
                              max: gameViewModel.enemyMaxHealth)
                    .padding()
                }
                
                ProgressView("Distance", value: Float(gameViewModel.distanceTraveled), total: 100)
                //      .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        scene.applyExtraDamage()
                    }) {
                        Text("Extra Attack")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        scene.restartGame()
                    }) {
                        Text("Res")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.bottom, 50)
            }
            
            if gameViewModel.gameEnded {
                GameSummaryView(viewModel: gameViewModel)
                    .frame(width: 300, height: 300)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
            }
        }
    }
}

struct HPBarView: View {
    var title: String
    var current: Int
    var max: Int
    
    var clampedCurrent: Int {
        // Если max равен 0, возвращаем 0, чтобы не было деления на ноль.
        guard max > 0 else { return 0 }
        return Swift.max(0, min(current, max))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
            ProgressView(value: Float(clampedCurrent), total: Float(max > 0 ? max : 1))                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .frame(width: 150)
        }
        .padding(8)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
    }
}

struct GameSummaryView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Game Summary")
                .font(.title)
                .bold()
            Text("Total Enemies Killed: \(viewModel.totalEnemiesKilled)")
            Text("Total Time: \(String(format: "%.1f", viewModel.totalTime)) sec")
            Text("Health Lost: \(viewModel.healthLost)")
            Text("Total Damage: \(viewModel.totalDamageDealt)")
            Text("Pepper Usage: \(viewModel.pepperUsage)")
            Button("Close") {
                // Здесь можно добавить логику перезапуска игры
            }
            .padding(.top, 10)
        }
        .padding()
    }
}