import SwiftUI
import SpriteKit


// MARK: - SwiftUI интерфейс для отображения игры
struct GameViewCTD: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var statVM: StatisticsViewModelCTD
    
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
            
            VStack {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        statVM.matchesPlayed += 1
                    } label: {
                        Image(.homeIconCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                    }
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ZStack {
                                Image(.itemBgCTD)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 120:85)
                                
                                switch shopVM.currentTeamItem {
                                case "hero1":
                                    Image(.item1ImageCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:80)
                                case "hero2":
                                    Image(.item2ImageCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:80)
                                case "hero3":
                                    Image(.item3ImageCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 110:80)
                                    
                                default:
                                    Image(.item1ImageCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
                                }
                            }
                            
                            VStack(spacing: -5) {
                                ZStack {
                                    Image(.progressBgCTD)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    HStack(spacing: 0) {
                                        ProgressView("", value: Float(gameViewModel.distanceTraveled), total: 100)
                                            .tint(.orange)
                                            .offset(y: -10)
                                            .padding(.horizontal)
                                            .scaleEffect(x: 1, y: 3, anchor: .center)
                                        
                                        Text("\(Int(gameViewModel.distanceTraveled))%")
                                            .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 30:15, weight: .regular))
                                            .foregroundStyle(.white)
                                    }.padding(.trailing)
                                    
                                }
                                
                                HStack {
                                    Image(.underProgressCTD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 60:34)
                                }
                                
                            }
                        }
                        
                        HStack {
                            HPBarView(title: "Hero HP",
                                      current: gameViewModel.heroHealth,
                                      max: gameViewModel.heroMaxHealth)
                            
                            Image(.vsTextCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 58:39,height: CTDDeviceManager.shared.deviceType == .pad ? 78:39)
                            
                            HPBarView(title: "Enemy HP",
                                      current: gameViewModel.enemyHealth,
                                      max: gameViewModel.enemyMaxHealth)
                            
                            
                        }
                        
                    }
                       
                    
                    MoneyViewCTD()
                    
                }.padding([.horizontal])
            
            
                Spacer()
                
                HStack {
                    Button(action: {
                        scene.applyExtraDamage()
                    }) {
                        ZStack {
                            Image(.deskBgCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 122:61)
                            
                            Text("Click")
                                .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 56:28, weight: .black))
                                .foregroundStyle(.white)
                                
                        }
                    }
                    
                    
                }
                .padding(.bottom, 0)
            }
            
            if gameViewModel.gameEnded {
                GameSummaryView(viewModel: gameViewModel, victory: gameViewModel.gameWin) {
                    scene.restartGame()
                    statVM.monstersKilled += gameViewModel.totalEnemiesKilled
                    statVM.matchesPlayed += 1
                    if gameViewModel.gameWin {
                        statVM.defeatedBosses += 1
                    }
                    statVM.maxHeroLevel = 4
                    statVM.totalTime += gameViewModel.totalTime
                } rightBtn: {
                    statVM.monstersKilled += gameViewModel.totalEnemiesKilled
                    statVM.matchesPlayed += 1
                    if gameViewModel.gameWin {
                        statVM.defeatedBosses += 1
                    }
                    statVM.maxHeroLevel = 4
                    statVM.totalTime += gameViewModel.totalTime
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct HPBarView: View {
    var title: String
    var current: Int
    var max: Int
    
    var clampedCurrent: Int {
        guard max > 0 else { return 0 }
        return Swift.max(0, min(current, max))
    }
    
    var body: some View {
        HStack {
            Image(.heartIconCTD)
                .resizable()
                .scaledToFit()
                .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 74:37,height: CTDDeviceManager.shared.deviceType == .pad ? 74:37)
            ZStack {
                Image(.progressBgCTD)
                    .resizable()
                    .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 250:190, height: CTDDeviceManager.shared.deviceType == .pad ? 74:37)
                    .scaledToFill()
                    
                HStack {
                    
                    ProgressView(value: Float(clampedCurrent), total: Float(max > 0 ? max : 1))                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 230:150)
                        .scaleEffect(x: 1, y: CTDDeviceManager.shared.deviceType == .pad ? 4:2, anchor: .center)
                }
                .padding(CTDDeviceManager.shared.deviceType == .pad ? 12:6)
                .background(Color.black.opacity(1))
                .cornerRadius(8)
            }
        }
    }
}

struct GameSummaryView: View {
    @ObservedObject var viewModel: GameViewModel
    var victory: Bool
    var leftBtn: () -> ()
    var rightBtn: () -> ()
    var body: some View {
        VStack {
            ZStack {
                Image(.settingsBgCTD)
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    if victory {
                        Image(.winTextCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 260:130)
                    } else {
                        Image(.winTextCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 260:130)
                            .opacity(0)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Total Enemies Killed: \(viewModel.totalEnemiesKilled)")
                        Text("Total Time: \(String(format: "%.1f", viewModel.totalTime)) sec")
                        Text("Health Lost: \(viewModel.healthLost)")
                        Text("Total Damage: \(viewModel.totalDamageDealt)")
                        
                    }.font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 50:25, weight: .bold))
                        .foregroundStyle(.white)
                    
                    HStack {
                        
                        Button(action: {
                            leftBtn()
                        }) {
                            ZStack {
                                Image(.deskBgCTD)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 310:155,height: CTDDeviceManager.shared.deviceType == .pad ? 122:61)
                                
                                Text("Play again")
                                    .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 44:22, weight: .black))
                                    .foregroundStyle(.white)
                                    
                            }
                        }
                        
                        Button(action: {
                            rightBtn()
                        }) {
                            ZStack {
                                Image(.deskBgCTD)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: CTDDeviceManager.shared.deviceType == .pad ? 310:155,height: CTDDeviceManager.shared.deviceType == .pad ? 122:61)
                                    
                                
                                Text("Main menu")
                                    .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 44:22, weight: .black))
                                    .foregroundStyle(.white)
                                    
                            }
                        }
                    }
                    
                }
            }
            Spacer()
        }
    }
}

#Preview {
    GameViewCTD(statVM: StatisticsViewModelCTD())
}
