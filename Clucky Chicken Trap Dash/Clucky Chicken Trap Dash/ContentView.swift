//
//  ContentView.swift
//  Clucky Chicken Trap Dash
//
//  Created by Dias Atudinov on 27.03.2025.
//

import SwiftUI
import SpriteKit

// MARK: - SKScene для битвы
class BattleScene: SKScene {
    // Узлы для героя и врага
    var hero: SKSpriteNode!
    var enemy: SKSpriteNode!
    
    // Здоровье и максимальное здоровье
    let heroMaxHealth = 100
    let enemyMaxHealth = 100
    var heroHealth: Int = 100 {
        didSet { updateHealthBars() }
    }
    var enemyHealth: Int = 100 {
        didSet { updateHealthBars() }
    }
    
    // Узлы здоровья (зеленые полоски на фоне красных)
    var heroHealthBar: SKSpriteNode!
    var enemyHealthBar: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Настройка героя: спрайт и анимация бега на месте
        hero = SKSpriteNode(imageNamed: "heroRun1")
        hero.position = CGPoint(x: size.width * 0.25, y: size.height / 2)
        addChild(hero)
        startHeroRunningAnimation()
        
        // Настройка врага: спрайт и его позиция
        enemy = SKSpriteNode(imageNamed: "enemyRun1")
        enemy.position = CGPoint(x: size.width * 0.75, y: size.height / 2)
        addChild(enemy)
        
        // Создаем и добавляем индикаторы здоровья
        setupHealthBars()
        
        // Запускаем цикл битвы (автоатаки)
        startBattleCycle()
    }
    
    // Запускаем циклическую анимацию бега героя (на месте)
    func startHeroRunningAnimation() {
        let runTextures = [
            SKTexture(imageNamed: "heroRun1"),
            SKTexture(imageNamed: "heroRun2")
        ]
        let runAnimation = SKAction.animate(with: runTextures, timePerFrame: 0.1)
        let runLoop = SKAction.repeatForever(runAnimation)
        hero.run(runLoop, withKey: "heroRunning")
    }
    
    // Создаем полосы здоровья для героя и врага
    func setupHealthBars() {
        let barWidth: CGFloat = 100
        let barHeight: CGFloat = 10
        
        // Герой
        let heroHealthBackground = SKSpriteNode(color: .red, size: CGSize(width: barWidth, height: barHeight))
        heroHealthBackground.position = CGPoint(x: hero.position.x, y: hero.position.y + hero.size.height/2 + 20)
        addChild(heroHealthBackground)
        
        heroHealthBar = SKSpriteNode(color: .green, size: CGSize(width: barWidth, height: barHeight))
        heroHealthBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        heroHealthBar.position = CGPoint(x: heroHealthBackground.position.x - barWidth/2, y: heroHealthBackground.position.y)
        addChild(heroHealthBar)
        
        // Враг
        let enemyHealthBackground = SKSpriteNode(color: .red, size: CGSize(width: barWidth, height: barHeight))
        enemyHealthBackground.position = CGPoint(x: enemy.position.x, y: enemy.position.y + enemy.size.height/2 + 20)
        addChild(enemyHealthBackground)
        
        enemyHealthBar = SKSpriteNode(color: .green, size: CGSize(width: barWidth, height: barHeight))
        enemyHealthBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        enemyHealthBar.position = CGPoint(x: enemyHealthBackground.position.x - barWidth/2, y: enemyHealthBackground.position.y)
        addChild(enemyHealthBar)
    }
    
    // Обновляем полосы здоровья
    func updateHealthBars() {
        let heroRatio = CGFloat(heroHealth) / CGFloat(heroMaxHealth)
        let enemyRatio = CGFloat(enemyHealth) / CGFloat(enemyMaxHealth)
        heroHealthBar.xScale = max(heroRatio, 0)
        enemyHealthBar.xScale = max(enemyRatio, 0)
    }
    
    // Запуск цикла автоатаки – каждые 2 секунды
    func startBattleCycle() {
        let attackCycle = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { [weak self] in
                self?.performAttackCycle()
            }
        ])
        run(SKAction.repeatForever(attackCycle))
    }
    
    // Логика автоатаки: анимация удара с движением (шаг вперед и назад), рассчет урона и показ урона
    func performAttackCycle() {
        // Сохраняем текущие позиции
        let heroOriginalPos = hero.position
        let enemyOriginalPos = enemy.position
        
        // Анимация шага: герой движется немного вправо (в сторону врага), враг – влево
        let heroStep = SKAction.sequence([
            SKAction.moveBy(x: 10, y: 0, duration: 0.1),
            SKAction.move(to: heroOriginalPos, duration: 0.1)
        ])
        let enemyStep = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.1),
            SKAction.move(to: enemyOriginalPos, duration: 0.1)
        ])
        hero.run(heroStep)
        enemy.run(enemyStep)
        
        // Запускаем анимацию удара героя (покадровая)
        let heroAttackTextures = [
            SKTexture(imageNamed: "heroHit1"),
            SKTexture(imageNamed: "heroHit2")
        ]
        let heroAttackAnimation = SKAction.animate(with: heroAttackTextures, timePerFrame: 0.2)
        hero.run(heroAttackAnimation)
        
        // Запускаем анимацию удара врага
        let enemyAttackTextures = [
            SKTexture(imageNamed: "enemyHit1"),
            SKTexture(imageNamed: "enemyHit2")
        ]
        let enemyAttackAnimation = SKAction.animate(with: enemyAttackTextures, timePerFrame: 0.2)
        enemy.run(enemyAttackAnimation)
        
        // Базовый урон автоатаки
        let baseDamage = 10
        
        enemyHealth -= baseDamage
        heroHealth -= baseDamage
        
        // Показ урона
        showDamage(on: enemy, damage: baseDamage)
        showDamage(on: hero, damage: baseDamage)
        
        print("Герой наносит \(baseDamage) урона. Здоровье врага: \(enemyHealth)")
        print("Враг наносит \(baseDamage) урона. Здоровье героя: \(heroHealth)")
        
        checkBattleStatus()
    }
    
    // Функция для отображения урона с рандомным смещением внутри границ персонажа
    func showDamage(on node: SKSpriteNode, damage: Int) {
        let damageLabel = SKLabelNode(text: "-\(damage)")
        damageLabel.fontName = "Helvetica-Bold"
        damageLabel.fontSize = 20
        damageLabel.fontColor = .red
        
        // Рандомное смещение внутри размеров узла
        let halfWidth = node.size.width / 2
        let halfHeight = node.size.height / 2
        let randomX = CGFloat.random(in: -halfWidth...halfWidth)
        let randomY = CGFloat.random(in: -halfHeight...halfHeight)
        damageLabel.position = CGPoint(x: node.position.x + randomX, y: node.position.y + randomY)
        addChild(damageLabel)
        
        let moveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let group = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()
        damageLabel.run(SKAction.sequence([group, remove]))
    }
    
    // Обработка нажатия кнопки – мгновенное нанесение дополнительного урона
    func applyExtraDamage() {
        let extraDamage = 5
        enemyHealth -= extraDamage
        showDamage(on: enemy, damage: extraDamage)
        print("Клик! Дополнительный урон \(extraDamage). Здоровье врага: \(enemyHealth)")
        checkBattleStatus()
    }
    
    // Проверка состояния битвы (победа/поражение)
    func checkBattleStatus() {
        if enemyHealth <= 0 {
            enemyDefeated()
        }
        if heroHealth <= 0 {
            heroDefeated()
        }
    }
    
    // Обработка победы над врагом:
    // Герой остается на месте (бег на месте), а новый враг появляется из-за правой границы экрана и занимает позицию предыдущего врага.
    func enemyDefeated() {
        print("Враг побеждён!")
        // Восстанавливаем здоровье героя
        heroHealth = heroMaxHealth
        
        // Анимация исчезновения врага
        let fadeOutEnemy = SKAction.fadeOut(withDuration: 0.5)
        enemy.run(fadeOutEnemy) {
            // Запоминаем позицию побежденного врага
            let targetPosition = self.enemy.position
            self.enemy.removeFromParent()
            
            // Создаем нового врага, появляющегося из-за правой границы экрана
            let newEnemy = SKSpriteNode(imageNamed: "enemyRun1")
            let startX = self.size.width + newEnemy.size.width / 2
            newEnemy.position = CGPoint(x: startX, y: targetPosition.y)
            newEnemy.alpha = 0.0
            self.enemy = newEnemy
            self.addChild(newEnemy)
            
            // Обновляем здоровье врага и его индикатор
            self.enemyHealth = self.enemyMaxHealth
            self.enemyHealthBar.removeFromParent()
            let barWidth: CGFloat = 100
            let barHeight: CGFloat = 10
            let enemyHealthBackground = SKSpriteNode(color: .red, size: CGSize(width: barWidth, height: barHeight))
            enemyHealthBackground.position = CGPoint(x: newEnemy.position.x, y: newEnemy.position.y + newEnemy.size.height/2 + 20)
            self.addChild(enemyHealthBackground)
            
            self.enemyHealthBar = SKSpriteNode(color: .green, size: CGSize(width: barWidth, height: barHeight))
            self.enemyHealthBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            self.enemyHealthBar.position = CGPoint(x: enemyHealthBackground.position.x - barWidth/2, y: enemyHealthBackground.position.y)
            self.addChild(self.enemyHealthBar)
            
            // Анимация появления и движения нового врага на позицию предыдущего
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let moveToTarget = SKAction.move(to: targetPosition, duration: 1.0)
            let group = SKAction.group([fadeIn, moveToTarget])
            newEnemy.run(group)
        }
    }
    
    // Обработка поражения героя
    func heroDefeated() {
        print("Герой проиграл! Игра окончена.")
        // Здесь можно реализовать перезапуск игры или переход в другое состояние
    }
}

// MARK: - SwiftUI интерфейс с интеграцией SpriteKit
struct ContentView: View {
    // Сохраняем экземпляр сцены, чтобы не создавать новый при каждом доступе
    @State private var scene = BattleScene(size: CGSize(width: 800, height: 600))
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                // Кнопка для нанесения дополнительного урона
                Button(action: {
                    scene.applyExtraDamage()
                }) {
                    Text("Кликни для дополнительного урона")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    ContentView()
}
