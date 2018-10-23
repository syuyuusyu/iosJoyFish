//
//  BulletSpirt.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/23.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

class BulletSpirt :SKSpriteNode,AfterAddToGameScene{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var level :Int
    var direction :CGFloat
    
    static private var textureMap:[String:SKTexture] = [
        "bullet1" : SKTexture(imageNamed: "bullet1"),
        "bullet2" : SKTexture(imageNamed: "bullet2"),
        "bullet3" : SKTexture(imageNamed: "bullet3"),
        "bullet4" : SKTexture(imageNamed: "bullet4"),
        "bullet5" : SKTexture(imageNamed: "bullet5"),
        "bullet6" : SKTexture(imageNamed: "bullet6"),
        "bullet7" : SKTexture(imageNamed: "bullet7"),
        "bullet8" : SKTexture(imageNamed: "bullet8"),
    ]
    
    init(level:Int,direction:CGFloat,at point :CGPoint){
        self.level = level
        self.direction = direction
        guard let texture = BulletSpirt.textureMap["bullet\(level)"] else {
            fatalError("init() image bullet\(level) not exiset")
        }
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        name = "bullet"
        xScale = JoyFishConstant.Scale
        yScale = JoyFishConstant.Scale
        anchorPoint = CGPoint(x:0,y:0.5)
        position = point
        zPosition = JoyFishConstant.bulletzPosition
        zRotation = CGFloat.pi/2 - direction
        speed = 2
        
        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = JoyFishConstant.bulletCategoryBitMask
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = JoyFishConstant.fishCategoryBitMask
    }
    
    deinit {
        print("bullet out!!!")
    }
    
    public func collide(){
        let web = WebSpirt(level: level, at: position)
        scene?.addChild(web)
        removeAction(forKey: "move")
        removeFromParent()
    }
    
    func afterAddToScene() {
        let duration = TimeInterval(Int.max)
        let moveAction = SKAction.customAction(withDuration:duration,actionBlock:{ (node,elapsedTime)  in
            if let node = node as? SKSpriteNode{
                node.position.x += sin(self.direction) * self.speed
                node.position.y += cos(self.direction) * self.speed
        
                //node.zRotation =  self.direction
                if node.position.x > (node.scene?.view?.bounds.width)!+210
                    || node.position.y > (node.scene?.view?.bounds.height)!+210
                    || node.position.x < -210
                    || node.position.y < -210 {
                    node.removeAction(forKey: "move")
                    node.removeFromParent()
                }
            }
        })
        run(moveAction,withKey:"move")
    }
}
