//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Grant Watson on 10/17/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var target: SKSpriteNode!
    var timeRemaining: SKLabelNode!
    
    var nodeArray = [SKSpriteNode]()
    var targetTimer: Timer?
    var countdownTimer: Timer?
    var randomTimeInt = 1.0
    
    var isGameOver = false
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var time = 60 {
        didSet {
            timeRemaining.text = "\(time)"
            if time == 0 {
                isGameOver = true
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let curtains = SKSpriteNode(imageNamed: "curtain")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.zPosition = 0.99
        addChild(curtains)
        
        timeRemaining = SKLabelNode(text: "60")
        timeRemaining.fontName = "Impact"
        timeRemaining.position = CGPoint(x: 900, y: 660)
        timeRemaining.zPosition = 1
        addChild(timeRemaining)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "Impact"
        scoreLabel.position = CGPoint(x: 30, y: 60)
        scoreLabel.zPosition = 1
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        for i in 0..<3 { createTrack(at: CGPoint(x: 512, y: 384 - (117 * i) ))}
        
        physicsWorld.gravity = .zero
        
        targetTimer = Timer.scheduledTimer(timeInterval: randomTimeInt, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        for node in nodes {
            guard let target = node.parent as? Target else { continue }
            if node.xScale > 0.5 {
                if node.name == "good" {
                    self.score += 1
                } else if node.name == "bad" {
                    self.score -= 1
                }
            } else {
                if node.name == "good" {
                    self.score += 5
                } else if node.name == "bad" {
                    self.score -= 5
                }
            }
            
            let hide = SKAction.fadeOut(withDuration: 0.2)
            target.run(hide)
            target.removeFromParent()
            
            if let explosion = SKEmitterNode(fileNamed: "explosion") {
                explosion.position = node.position
                addChild(explosion)
            }
        }
    }
    
    func createTrack(at position: CGPoint) {
        let track = SKSpriteNode(imageNamed: "track")
        track.position = position
        track.zPosition = 0.97
        addChild(track)
    }
    
    @objc func createTarget() {
        let target = Target()
        target.configure()
        addChild(target)
        nodeArray.append(target)
        
        if time == 0 {
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            targetTimer?.invalidate()
            countdownTimer?.invalidate()
            isUserInteractionEnabled = false
        }
    }
    
    @objc func countdown() {
        time -= 1
        
        if time % 3 == 0 {
            self.targetTimer?.invalidate()
            self.randomTimeInt = Double.random(in: 0.5...1.0)
            self.targetTimer = Timer.scheduledTimer(timeInterval: randomTimeInt, target: self, selector: #selector(self.createTarget), userInfo: nil, repeats: true)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        for node in nodeArray {
            if node.position.x < 0 || node.position.x > 1200 {
                node.removeFromParent()
            }
            node.removeFromParent()
        }
    }
}
