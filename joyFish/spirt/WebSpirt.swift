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

        physicsBody = //SKPhysicsBody(texture: texture, size: size)
            SKPhysicsBody(circleOfRadius: size.height, center: position)
        print("height",size.height)
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = JoyFishConstant.webCategoryBitMask
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = JoyFishConstant.fishCategoryBitMask
        
    }
    
    public func afterAddToScene() {
        
    }
}
