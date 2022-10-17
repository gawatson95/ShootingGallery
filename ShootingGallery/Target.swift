//
//  Target.swift
//  ShootingGallery
//
//  Created by Grant Watson on 10/17/22.
//

import GameKit
import Foundation

class Target: SKSpriteNode {
    
    func configure() {
        let random = Int.random(in: 0...2)
        
        let yCoords = [384, 267, 150]
        let scaleToVelocity = [0.3:600, 0.5:500, 0.6:400, 0.75:300].randomElement()
        
        let target = SKSpriteNode(imageNamed: random == 0 ? "badTarget" : "goodTarget")
        target.name = random == 0 ? "bad" : "good"
        
        target.position = CGPoint(x: random == 1 ? 1000 : 0, y: yCoords[random])
        target.zPosition = 0.98
        target.setScale(scaleToVelocity!.key)
        
        target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
        target.physicsBody?.linearDamping = 0
        target.physicsBody?.velocity = CGVector(dx: random == 1 ? -scaleToVelocity!.value : scaleToVelocity!.value, dy: 0)
        addChild(target)
    }
}
