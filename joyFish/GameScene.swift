//
//  GameScene.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/17.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var fishs : [FishSprit] {
        return children.filter{ $0.name == "fish"}.map{  $0 as! FishSprit }
    }
    
    var cannon :CannonSpirt {
        return children.filter{ $0.name == "cannon"}.map{ $0 as! CannonSpirt}[0]
    }
    
    func createFishAction() {
        let waitAct = SKAction.wait(forDuration: 2, withRange: 1)
        let createAct = SKAction.run {
            self.initFishSpirt()
        }
        run(SKAction.repeatForever(SKAction.sequence([waitAct, createAct])), withKey: "createFish")
    }
    
    override func didMove(to view: SKView) {
        initBackGround(view)
        createFishAction()
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        //fishs.forEach{ $0.checkOut() }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location:CGPoint! = touches.first?.location(in: self)
        if (cannon.cannonLevelDownSpirt?.frame.contains(location))! {
            cannon.decreaseLevel()
        }else if (cannon.cannonLevelUpSpirt?.frame.contains(location))! {
            cannon.increaseLevel()
        }else{
            cannon.fire(target: location)
        }
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        var bodyA : SKPhysicsBody
        var bodyB : SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        }else {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        if let _ = bodyB.node as? FishSprit,let bullet = bodyA.node as? BulletSpirt{
            bullet.collide()
        }
        if let _ = bodyB.node as? FishSprit,let web = bodyA.node as? WebSpirt{
            print(11111)
            print(web)
        }

        
    }
}
