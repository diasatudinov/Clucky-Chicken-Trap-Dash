import SwiftUI
import SpriteKit

// MARK: - Основной класс игровой сцены
class BattleScene: SKScene {
    // Фоновое изображение
    var bg1: SKSpriteNode!
    var bg2: SKSpriteNode!
    
    // Узлы для героя и врага
    var hero: SKSpriteNode!
    var enemy: SKSpriteNode!
    
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
    
    // Узлы полос здоровья
    var heroHealthBar: SKSpriteNode!
    var enemyHealthBar: SKSpriteNode!
    
    // Индекс текущего врага (от 0 до 5, где 5 – босс)
    var currentEnemyIndex: Int = 0
    let totalEnemies: Int = 6  // 5 обычных + 1 босс
    
    // Ключ для цикла автоатаки
    let battleCycleKey = "battleCycle"
    
    var isTransitioning = false
    var transitionDistanceRemaining: CGFloat = 0
    var transitionSpeed: CGFloat = 0  // пикселей в секунду
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Настройка фонового изображения
        let bgTexture = SKTexture(imageNamed: "field1CTD")
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
        hero = SKSpriteNode(imageNamed: "heroRun1")
        hero.position = CGPoint(x: size.width * 0.25, y: size.height/2)
        addChild(hero)
        startHeroRunningAnimation()
        
        // Создание полосы здоровья героя
        setupHeroHealthBar()
        
        // Спавн первого врага
        spawnEnemy()
        
        // Запуск цикла автоатаки
        startBattleCycle()
    }
    
    // MARK: Анимация героя
    func startHeroRunningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "heroRun1"),
            SKTexture(imageNamed: "heroRun2")
        ]
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runLoop = SKAction.repeatForever(runAnimation)
        hero.run(runLoop, withKey: "heroRunning")
    }
    
    // MARK: Полосы здоровья
    func setupHeroHealthBar() {
        let barWidth: CGFloat = 100
        let barHeight: CGFloat = 10
        
        // Фон для полосы героя
        let heroHealthBackground = SKSpriteNode(color: .red, size: CGSize(width: barWidth, height: barHeight))
        heroHealthBackground.position = CGPoint(x: hero.position.x, y: hero.position.y + hero.size.height/2 + 20)
        addChild(heroHealthBackground)
        
        heroHealthBar = SKSpriteNode(color: .green, size: CGSize(width: barWidth, height: barHeight))
        heroHealthBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        heroHealthBar.position = CGPoint(x: heroHealthBackground.position.x - barWidth/2, y: heroHealthBackground.position.y)
        addChild(heroHealthBar)
    }
    
    func setupEnemyHealthBar() {
        let barWidth: CGFloat = 100
        let barHeight: CGFloat = 10
        
        // Фон для полосы врага
        let enemyHealthBackground = SKSpriteNode(color: .red, size: CGSize(width: barWidth, height: barHeight))
        enemyHealthBackground.position = CGPoint(x: enemy.position.x, y: enemy.position.y + enemy.size.height/2 + 20)
        addChild(enemyHealthBackground)
        
        enemyHealthBar = SKSpriteNode(color: .green, size: CGSize(width: barWidth, height: barHeight))
        enemyHealthBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        enemyHealthBar.position = CGPoint(x: enemyHealthBackground.position.x - barWidth/2, y: enemyHealthBackground.position.y)
        addChild(enemyHealthBar)
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
            
            // Двигаем оба фоновых узла влево
            bg1.position.x -= moveAmount
            bg2.position.x -= moveAmount
            
            // Бесшовный скроллинг: если один фон полностью ушёл за экран, перемещаем его вправо за второй
            if bg1.position.x + bg1.size.width < 0 {
                bg1.position.x = bg2.position.x + bg2.size.width - 1
            }
            if bg2.position.x + bg2.size.width < 0 {
                bg2.position.x = bg1.position.x + bg1.size.width - 1
            }
            
            // Если сдвиг завершён – завершаем переход
            if transitionDistanceRemaining <= 0 {
                isTransitioning = false
                // Останавливаем анимацию переходного бега и возвращаем основную анимацию героя
                hero.removeAction(forKey: "transitionRunning")
                startHeroRunningAnimation()
                
                // Спавним следующего врага
                currentEnemyIndex += 1
                spawnEnemy()
                startBattleCycle()
            }
        }
        
        // Если не в переходе, можно оставить фон на месте (или, если нужна непрерывная прокрутка – добавить логику для движения)
        // Бесшовный скроллинг всегда актуален:
        if bg1.position.x + bg1.size.width < 0 {
            bg1.position.x = bg2.position.x + bg2.size.width - 1
        }
        if bg2.position.x + bg2.size.width < 0 {
            bg2.position.x = bg1.position.x + bg1.size.width - 1
        }
    }
    
    
    func updateHealthBars() {
        let heroRatio = CGFloat(heroHealth) / CGFloat(heroMaxHealth)
        heroHealthBar?.xScale = max(heroRatio, 0)
        
        let enemyRatio = CGFloat(enemyHealth) / CGFloat(enemyMaxHealth)
        enemyHealthBar?.xScale = max(enemyRatio, 0)
    }
    
    // MARK: Спавн врага
    func spawnEnemy() {
        enemy?.removeFromParent()
        enemyHealthBar?.removeFromParent()
        
        heroHealth = 100
        enemy = SKSpriteNode(imageNamed: "enemyRun1")
        // Враг появляется за пределами правой стороны экрана
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: size.height/2)
        addChild(enemy)
        
        // Анимация входа: враг заезжает на позицию (например, x = 75% ширины экрана)
        let targetX = size.width * 0.75
        let moveAction = SKAction.moveTo(x: targetX, duration: 1.0)
        enemy.run(moveAction)
        
        // Увеличиваем здоровье врага с каждым новым (первые 5 – обычные, 6-й – босс)
        enemyMaxHealth = 100 + currentEnemyIndex * 20
        enemyHealth = enemyMaxHealth
        setupEnemyHealthBar()
        print("Появился враг \(currentEnemyIndex + 1) с здоровьем \(enemyHealth)")
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
        
        // Анимация удара (смена кадров)
        let heroAttackTextures = [
            SKTexture(imageNamed: "heroHit1"),
            SKTexture(imageNamed: "heroHit2")
        ]
        let heroAttackAnim = SKAction.animate(with: heroAttackTextures, timePerFrame: 0.2)
        hero.run(heroAttackAnim)
        
        let enemyAttackTextures = [
            SKTexture(imageNamed: "enemyHit1"),
            SKTexture(imageNamed: "enemyHit2")
        ]
        let enemyAttackAnim = SKAction.animate(with: enemyAttackTextures, timePerFrame: 0.2)
        enemy.run(enemyAttackAnim)
        
        // Рассчитываем урон – базовый урон растёт с каждым новым врагом
        let damage = 10 + currentEnemyIndex * 2
        enemyHealth -= damage
        heroHealth -= damage
        
        showDamage(on: enemy, damage: damage)
        showDamage(on: hero, damage: damage)
        
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
            
            // Если побеждён последний враг (босс) – завершаем игру победой
            if self.currentEnemyIndex == self.totalEnemies - 1 {
                self.victory()
                return
            }
            
            // Переключаем героя на анимацию переходного бега (с 4 изображениями)
            self.hero.removeAction(forKey: "heroRunning")
            self.startTransitionRunningAnimation()
            
            // Запускаем переход: фон будет сдвигаться влево, создавая эффект перебега
            // Здесь фон сдвинется на 30% ширины экрана за 1.5 сек
            self.isTransitioning = true
            self.transitionDistanceRemaining = self.size.width * 0.3
            self.transitionSpeed = self.transitionDistanceRemaining / 1.5
            // Пока update(_:) будет двигать фон – после завершения перехода будут вызваны spawnEnemy() и startBattleCycle()
        }
    }
    
    func startTransitionRunningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "runImage1"),
            SKTexture(imageNamed: "runImage2"),
            SKTexture(imageNamed: "runImage3"),
            SKTexture(imageNamed: "runImage4")
        ]
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runLoop = SKAction.repeatForever(runAnimation)
        hero.run(runLoop, withKey: "transitionRunning")
    }
    
    func heroDefeated() {
        print("Герой погиб! Игра окончена.")
        removeAllActions()
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .black
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOverLabel)
    }
    
    func victory() {
        print("Победа! Босс побеждён!")
        removeAllActions()
        let victoryLabel = SKLabelNode(text: "Victory!")
        victoryLabel.fontSize = 40
        victoryLabel.fontColor = .black
        victoryLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(victoryLabel)
    }
}

// MARK: - SwiftUI интерфейс для отображения игры
struct ContentView: View {
    @State private var scene = BattleScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            // Пример кнопки для дополнительной атаки (если требуется)
            VStack {
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
        }
    }
}

extension BattleScene {
    // Метод для ручной атаки (если требуется)
    func applyExtraDamage() {
        let extraDamage = 5
        enemyHealth -= extraDamage
        showDamage(on: enemy, damage: extraDamage)
        print("Ручная атака: нанесено дополнительно \(extraDamage) урона")
        checkBattleStatus()
    }
}


#Preview {
    ContentView()
}
