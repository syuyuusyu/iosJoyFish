//
//  NetSpirt.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/23.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

class WebSpirt :SKSpriteNode,AfterAddToGameScene{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var textureMap :[String:SKTexture]=[
        "web1" : SKTexture(imageNamed: "web1"),
        "web2" : SKTexture(imageNamed: "web2"),
        "web3" : SKTexture(imageNamed: "web3"),
        "web4" : SKTexture(imageNamed: "web4"),
        "web5" : SKTexture(imageNamed: "web5"),
        "web6" : SKTexture(imageNamed: "web6"),
        "web7" : SKTexture(imageNamed: "web7"),
    ]
    
    var level:Int
    
    var colliedFishList = [FishSprit]()
    
    init(level:Int,at position:CGPoint){
        guard let texture = WebSpirt.textureMap["web\(level)"] else {
            fatalError("init() image web\(level) not exiset")
        }
        self.level = level
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        name = "web"
        self.position = position
        xScale = JoyFishConstant.Scale
        yScale = JoyFishConstant.Scale
        
        physicsBody = SKPhysicsBody(circleOfRadius:max(self.size.width/2,self.size.height/2))
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = JoyFishConstant.webCategoryBitMask
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = JoyFishConstant.fishCategoryBitMask
        
    }
    
    deinit {
        print("web.collisionCount",self.collisionCount)
    }
    
    var collisionCount = 0
    
    public func afterAddToScene() {
        let action = SKAction.customAction(withDuration: 2, actionBlock: { (node,elapsedTime)  in
            if elapsedTime > 0.1 {
                //print(self.collisionCount)
                node.physicsBody = nil
            }
            if let node = node as? WebSpirt{
                node.alpha -= 1/60
            }
        })
        run(action, completion: {
            self.removeFromParent()
        })
    }
}
