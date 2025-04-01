import SwiftUI
import SpriteKit

// MARK: - Основной класс игровой сцены
class BattleScene: SKScene {
    var viewModel: GameViewModel?
    // Фоновое изображение
    var bg1: SKSpriteNode!
    var bg2: SKSpriteNode!
    
    // Узлы для героя и врага
    var hero: SKSpriteNode!
    var enemy: SKSpriteNode!
    var man: SKSpriteNode!
    
    // Здоровье героя
    let heroMaxHealth: Int = 100
    var heroHealth: Int = 100 {
        didSet { updateHealthBars() }
    }
    
    // Здоровье врага (будет меняться для каждого нового врага)
    var enemyMaxHealth: Int = 100
    var enemyHealth: Int = 100 {
        didSet { updateHealthBars() }
    }
    
    var startTime: TimeInterval = 0
    
    // Узлы полос здоровья
    var heroHealthBar: SKSpriteNode!
    var enemyHealthBar: SKSpriteNode!
    var isBossRound = false
    var currentEnemyIndex: Int = 0 {
        didSet {
            if currentEnemyIndex + 1 == totalEnemies - 1 {
                isBossRound = true
            } else {
                isBossRound = false
            }
        }
    }
    let totalEnemies: Int = 6  // 5 обычных + 1 босс
    
    // Ключ для цикла автоатаки
    let battleCycleKey = "battleCycle"
    
    var isTransitioning = false
    var transitionDistanceRemaining: CGFloat = 0
    var transitionSpeed: CGFloat = 0  // пикселей в секунду
    var lastUpdateTime: TimeInterval = 0

    var currentEnemyType: String?
    
    override func didMove(to view: SKView) {
        backgroundColor = .systemMint
        
        startTime = CACurrentMediaTime()
        // Настройка фонового изображения
        let bgTexture = SKTexture(imageNamed: "field\(Int.random(in: 1...4))CTD")
        bg1 = SKSpriteNode(texture: bgTexture)
        bg1.anchorPoint = .zero
        bg1.position = .zero
        bg1.zPosition = -10
        bg1.size = self.size
        addChild(bg1)
        
        bg2 = SKSpriteNode(texture: bgTexture)
        bg2.anchorPoint = .zero
        // bg2 располагается сразу после bg1, чтобы не было зазора (отнимаем 1 пункт, чтобы избежать щели)
        bg2.position = CGPoint(x: bg1.size.width - 1, y: 0)
        bg2.zPosition = -10
        bg2.size = self.size
        addChild(bg2)
        

        
        
        // Настройка героя
        hero = SKSpriteNode(imageNamed: "heroRun2")
        hero.position = CGPoint(x: size.width * 0.25, y: size.height/2.9)
        hero.size = CGSize(width: 142, height: 160)
        addChild(hero)
        
        // Создаем персонажа "man", который находится позади героя
        man = SKSpriteNode(imageNamed: "manRun1")
        man.position = CGPoint(x: hero.position.x - 120, y: hero.position.y + 30) // смещён немного влево
        man.size = CGSize(width: 90, height: 210)
        man.zPosition = hero.zPosition - 1  // позади героя
        addChild(man)
        // В начале битвы герой стоит — поэтому "man" остается статичным
        stopManRunningAnimation()
        
        // Спавн первого врага
        spawnEnemy()
        
        // Запуск цикла автоатаки
        startBattleCycle()
    }
    
    func startManRunningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "manRun1"),
            SKTexture(imageNamed: "manRun2"),
            SKTexture(imageNamed: "manRun3"),
            SKTexture(imageNamed: "manRun4"),
            SKTexture(imageNamed: "manRun5"),
            SKTexture(imageNamed: "manRun6"),
            SKTexture(imageNamed: "manRun7"),
            SKTexture(imageNamed: "manRun8"),
            SKTexture(imageNamed: "manRun9"),
            SKTexture(imageNamed: "manRun10"),
        ]
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runLoop = SKAction.repeatForever(runAnimation)
        man.run(runLoop, withKey: "manRunning")
    }

    func stopManRunningAnimation() {
        man.removeAction(forKey: "manRunning")
        // Можно установить статичное изображение, если нужно
        man.texture = SKTexture(imageNamed: "manRun1")
    }

    func startBattleIdleAnimation() {
        // Можно использовать статичное изображение
        hero.texture = SKTexture(imageNamed: "heroRun2")
        
            // Останавливаем любые анимации бега
            hero.removeAction(forKey: "transitionRunning")
            
            // Останавливаем анимацию для "man"
            stopManRunningAnimation()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt: TimeInterval = 0
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        }
        lastUpdateTime = currentTime
        
        if isTransitioning {
            let moveAmount = transitionSpeed * CGFloat(dt)
            transitionDistanceRemaining -= moveAmount
            
            bg1.position.x -= moveAmount
            bg2.position.x -= moveAmount
            
            // Бесшовный скроллинг фона
            if bg1.position.x + bg1.size.width < 0 {
                bg1.position.x = bg2.position.x + bg2.size.width - 1
            }
            if bg2.position.x + bg2.size.width < 0 {
                bg2.position.x = bg1.position.x + bg1.size.width - 1
            }
            
            if transitionDistanceRemaining <= 0 {
                isTransitioning = false
                hero.removeAction(forKey: "transitionRunning")
                // После перехода герой возвращается в idle (боевая) анимацию
                startBattleIdleAnimation()
                currentEnemyIndex += 1
                startBattleCycle()
            }
        }
        
        // Постоянная проверка бесшовного скроллинга (если фон движется постоянно)
        if bg1.position.x + bg1.size.width < 0 {
            bg1.position.x = bg2.position.x + bg2.size.width - 1
        }
        if bg2.position.x + bg2.size.width < 0 {
            bg2.position.x = bg1.position.x + bg1.size.width - 1
        }
    }
    
    func updateHealthBars() {
        // Обновляем графику (если используется SKSpriteNode-полоса здоровья)
        // Например:
        let heroRatio = CGFloat(heroHealth) / CGFloat(heroMaxHealth)
        heroHealthBar?.xScale = max(heroRatio, 0)
        
        let enemyRatio = CGFloat(enemyHealth) / CGFloat(enemyMaxHealth)
        enemyHealthBar?.xScale = max(enemyRatio, 0)
        
        // Обновляем модель для SwiftUI
        viewModel?.heroHealth = heroHealth
        viewModel?.heroMaxHealth = heroMaxHealth
        viewModel?.enemyHealth = enemyHealth
        viewModel?.enemyMaxHealth = enemyMaxHealth
    }
    
    // MARK: Спавн врага
    func spawnEnemy() {
        enemy?.removeFromParent()
        enemyHealthBar?.removeFromParent()
        
        heroHealth = 100
        let enemyImageName = "\(getEnemyImageName())Hit1"
        enemy = SKSpriteNode(imageNamed: enemyImageName)
        // Враг появляется на позиции боя (например, 75% ширины экрана)
        enemy.position = CGPoint(x: size.width * 0.75, y: size.height / 2.5)
        enemy.size = CGSize(width: 142, height: 160)
        addChild(enemy)
        
        // Обновляем характеристики врага (увеличиваются с каждым новым)
        enemyMaxHealth = 100 + currentEnemyIndex * 20
        enemyHealth = enemyMaxHealth
       // setupEnemyHealthBar()
        
        print("Появился враг \(currentEnemyIndex + 1) с изображением \(enemyImageName) и здоровьем \(enemyHealth)")

    }
    
    // MARK: Цикл боя (автоатака)
    func startBattleCycle() {
        removeAction(forKey: battleCycleKey)
        let cycle = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { [weak self] in
                self?.performAttackCycle()
            }
        ])
        run(SKAction.repeatForever(cycle), withKey: battleCycleKey)
    }
    
    func performAttackCycle() {
        // Сохраняем исходные позиции для анимации «шага»
        let heroOriginalPos = hero.position
        let enemyOriginalPos = enemy.position
        
        let heroStep = SKAction.sequence([
            SKAction.moveBy(x: 10, y: 0, duration: 0.1),
            SKAction.move(to: heroOriginalPos, duration: 0.1)
        ])
        hero.run(heroStep)
        
        let enemyStep = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.1),
            SKAction.move(to: enemyOriginalPos, duration: 0.1)
        ])
        enemy.run(enemyStep)
        
        let enemyHitTextures = getEnemyHitAnimationTextures()
        let enemyAttackAnim = SKAction.animate(with: enemyHitTextures, timePerFrame: 0.08)
        enemy.run(enemyAttackAnim)
        
        // Рассчитываем урон – базовый урон растёт с каждым новым врагом
        let damage = 10 + currentEnemyIndex * 2
        enemyHealth -= damage
        heroHealth -= damage
        
        showDamage(on: enemy, damage: damage)
        showDamage(on: hero, damage: damage)
        
        viewModel?.totalDamageDealt += damage
        viewModel?.accumulatedDamageTaken += damage
        
        print("Герой и враг обменялись ударами, нанесено \(damage) урона.")
        
        checkBattleStatus()
    }
    
    func showDamage(on node: SKSpriteNode, damage: Int) {
        let label = SKLabelNode(text: "-\(damage)")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 20
        label.fontColor = .red
        label.position = node.position
        addChild(label)
        
        let moveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let group = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()
        label.run(SKAction.sequence([group, remove]))
    }
    
    func checkBattleStatus() {
        if enemyHealth <= 0 {
            enemyDefeated()
        }
        if heroHealth <= 0 {
            heroDefeated()
        }
    }
    
    // MARK: Переход к следующему врагу
    func enemyDefeated() {
        print("Враг \(currentEnemyIndex + 1) побеждён!")
        removeAction(forKey: battleCycleKey)
        
        // Анимация исчезновения врага
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        enemy.run(fadeOut) { [weak self] in
            guard let self = self else { return }
            self.enemy.removeFromParent()
            
            // Если это босс – завершаем игру победой
            if self.currentEnemyIndex == self.totalEnemies - 1 {
                self.endGame(victory: true)
                return
            }
            
            // Переключаем героя на переходную анимацию (4 кадра)
            self.hero.removeAction(forKey: "heroRunning")
            self.startTransitionRunningAnimation()
            
            // Переход длится 4 секунды. Пусть фон сдвинется влево на 30% ширины сцены.
            let transitionDuration: TimeInterval = 4.0
            let transitionDistance = self.size.width * 0.3
            self.isTransitioning = true
            self.transitionDistanceRemaining = transitionDistance
            self.transitionSpeed = transitionDistance / CGFloat(transitionDuration)
            
            // Спавним нового врага сразу во время перехода
            self.spawnEnemyDuringTransition(duration: transitionDuration)
        }
        
        viewModel?.totalEnemiesKilled += 1
        let totalKilled = currentEnemyIndex + 1
            // Обновляем пройденный путь как процент
            viewModel?.distanceTraveled = CGFloat(Double(totalKilled) / Double(totalEnemies) * 100)
        
        let transitionDistance = size.width * 0.3
//        viewModel?.distanceTraveled += transitionDistance
    }
    
    func startTransitionRunningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "heroRun1"),
            SKTexture(imageNamed: "heroRun2"),
            SKTexture(imageNamed: "heroRun3"),
            SKTexture(imageNamed: "heroRun4")
        ]
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runLoop = SKAction.repeatForever(runAnimation)
        hero.run(runLoop, withKey: "transitionRunning")
        
        startManRunningAnimation()
    }
    
    func spawnEnemyDuringTransition(duration: TimeInterval) {
        enemy?.removeFromParent()
        enemyHealthBar?.removeFromParent()
        
        let enemyImageName = "\(getEnemyImageName())Hit1"
        enemy = SKSpriteNode(imageNamed: enemyImageName)
        // Враг появляется за правой границей экрана
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: size.height / 2.5)
        enemy.size = CGSize(width: 142, height: 160)
        addChild(enemy)
        
        enemyMaxHealth = 100 + currentEnemyIndex * 20
        enemyHealth = enemyMaxHealth
       //setupEnemyHealthBar()
        
        print("Появляется враг \(currentEnemyIndex + 2) с изображением \(enemyImageName) и здоровьем \(enemyHealth)")
        
        let targetX = size.width * 0.75
        let moveAction = SKAction.moveTo(x: targetX, duration: duration)
        enemy.run(moveAction)
    }
    
    func heroDefeated() {
        print("Герой погиб! Игра окончена.")
        endGame(victory: false)
    }
    
//    func isBossRound() -> Bool {
//        return currentEnemyIndex == totalEnemies - 1
//    }
    
    func getEnemyHitAnimationTextures() -> [SKTexture] {
        guard let enemyType = currentEnemyType else {
            // Если тип не выбран, можно вернуть пустой массив или использовать значение по умолчанию.
            return []
        }
        
        // Формируем имена кадров удара на основе выбранного типа врага
        let hitImageNames = [
            "\(enemyType)Hit1",
            "\(enemyType)Hit2",
            "\(enemyType)Hit3",
            "\(enemyType)Hit4"
        ]
        return hitImageNames.map { SKTexture(imageNamed: $0) }
    }

    // Возвращает имя картинки для врага в зависимости от того, босс это или обычный враг.
    func getEnemyImageName() -> String {
        if isBossRound {
            let bossImages = ["boss1", "boss2", "boss3", "boss4"]
            let selected = bossImages.randomElement()!
            currentEnemyType = selected
            print("Boss round! Selected boss image: \(selected)")
            return selected
        } else {
            let enemyImages = ["enemy1", "enemy2", "enemy3"]
            let selected = enemyImages.randomElement()!
            currentEnemyType = selected
            print("Enemy round! Selected Enemy image: \(selected)")
            return selected
        }
    }
    
    func victory() {
        print("Победа! Босс побеждён!")
        removeAllActions()
    }
    
    func endGame(victory: Bool) {
        removeAllActions()
        // Подсчитываем общее время игры
        let endTime = CACurrentMediaTime()
        viewModel?.totalTime = endTime - startTime
        // Подсчитываем потерянное здоровье (например, сколько урона получил герой за всю игру)
        viewModel?.healthLost = viewModel?.accumulatedDamageTaken ?? 0
        
        // Устанавливаем флаг завершения игры
        viewModel?.gameEnded = true
    }
}

// MARK: - SwiftUI интерфейс для отображения игры
struct ContentView: View {
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

extension BattleScene {
    // Метод для ручной атаки (если требуется)
    func applyExtraDamage() {
        if !isTransitioning {
            let extraDamage = 15
            enemyHealth -= extraDamage
            showDamage(on: enemy, damage: extraDamage)
            print("Ручная атака: нанесено дополнительно \(extraDamage) урона")
            checkBattleStatus()
        }
    }
}

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

#Preview {
    ContentView()
}
