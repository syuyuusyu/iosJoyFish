//
//  CannonSpirt.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/21.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

class CannonSpirt :SKSpriteNode,AfterAddToGameScene{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let imageLength = 5
    
    private static let textureMap:[String:SKTexture] = [
        "cannon1":SKTexture(imageNamed: "cannon1"),
        "cannon2":SKTexture(imageNamed: "cannon2"),
        "cannon3":SKTexture(imageNamed: "cannon3"),
        "cannon4":SKTexture(imageNamed: "cannon4"),
        "cannon5":SKTexture(imageNamed: "cannon5"),
        "cannon6":SKTexture(imageNamed: "cannon6"),
        "cannon7":SKTexture(imageNamed: "cannon7")
    ]
    
    private static let animateTextureMap :[String:[SKTexture]] = {
        print("animateTextureMap")
        var map = [String:[SKTexture]]()
        for j in 1...CannonSpirt.textureMap.count{
            map["cannon\(j)"] = [SKTexture]()
            for  i in 0...CannonSpirt.imageLength-1 {
                let texture = SKTexture(rect: CGRect(x: 0.0, y: CGFloat(i)/CGFloat(CannonSpirt.imageLength), width: 1, height: 1/CGFloat(CannonSpirt.imageLength)),
                                        in: CannonSpirt.textureMap["cannon\(j)"]!)
                map["cannon\(j)"]?.append(texture)
            }
        }
        return map
    }()
    
    private var animateTextureList :[SKTexture] {
        return CannonSpirt.animateTextureMap["cannon\(level)"]!
    }
    
    
    
    private var level:Int = 7{
        didSet{
            if level > 7{
                level = 1
            }
            if level < 1 {
                level = 7
            }
            self.texture = self.animateTextureList[0]
        }
    }
    

    
    init(at position:CGPoint) {
        print("init")
        let texture = CannonSpirt.animateTextureMap["cannon\(level)"]![4]
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        name = "cannon"
        xScale = JoyFishConstant.Scale
        yScale = JoyFishConstant.Scale
        anchorPoint = CGPoint(x:0.5,y:0)
        zPosition = JoyFishConstant.backItemzPosition
        self.position = position
    }
    
    private var onFire = false
    
    public func fire(target targetCGPoint:CGPoint){
        if !onFire{
            let dx = targetCGPoint.x - position.x
            let dy = targetCGPoint.y - position.y
            let angle = atan2(dx,dy)
            zRotation =  -angle
            let fireAnimate = SKAction.animate(with: self.animateTextureList, timePerFrame: 0.1)
            onFire = true
            run(SKAction.repeat(fireAnimate, count: 1), completion: {
                let bullet = BulletSpirt(level: self.level, direction: angle,
                                         at: CGPoint(x:self.position.x+sin(angle)*30,y:self.position.y+cos(angle)*30))
                self.scene?.addChild(bullet)
                self.onFire = false
            })
        }

        
    }
    
    private var levelDownTextureList:[SKTexture]?
    private var levelUpTextureList:[SKTexture]?
    var cannonLevelDownSpirt :SKSpriteNode?
    var cannonLevelUpSpirt :SKSpriteNode?
    
    public func afterAddToScene(){
        levelDownTextureList = [SKTexture(imageNamed: "cannon_minus.png"),SKTexture(imageNamed: "cannon_minus_down.png"),SKTexture(imageNamed: "cannon_minus.png")]
        levelUpTextureList = [SKTexture(imageNamed: "cannon_plus.png"),SKTexture(imageNamed: "cannon_plus_down.png"),SKTexture(imageNamed: "cannon_plus.png")]
        
        
        cannonLevelDownSpirt = SKSpriteNode(texture: levelDownTextureList![0])
        cannonLevelUpSpirt = SKSpriteNode(texture: levelUpTextureList![0])
        
        cannonLevelDownSpirt?.name = "levelDown"
        cannonLevelDownSpirt?.anchorPoint = CGPoint(x:1,y:0.5)
        cannonLevelDownSpirt?.position = CGPoint(x: position.x-size.height, y: 40)
        
        cannonLevelUpSpirt?.name = "levelUp"
        cannonLevelUpSpirt?.anchorPoint = CGPoint(x:0,y:0.5)
        cannonLevelUpSpirt?.position = CGPoint(x: position.x+size.height, y: 40)
        
        scene?.addChild(cannonLevelDownSpirt!)
        scene?.addChild(cannonLevelUpSpirt!)
    }
    
    public func increaseLevel(){
        level += 1
        let increaseAnimate = SKAction.animate(with: levelUpTextureList!, timePerFrame: 0.1)
        cannonLevelUpSpirt?.run(SKAction.repeat(increaseAnimate, count: 1),
                                completion:{
                                    //print("+",self.levelUpTextureList![0])
                                    //self.cannonLevelUpSpirt?.texture = self.levelUpTextureList![0]
                                    //self.texture = self.animateTextureList[0]
                                })
    }
    
    public func decreaseLevel(){
        level -= 1
        let decreaseAnimate = SKAction.animate(with: levelDownTextureList!, timePerFrame: 0.1)
        cannonLevelDownSpirt?.run(SKAction.repeat(decreaseAnimate, count: 1),
                                  completion:{
                                    //print("-",self.levelUpTextureList![0])
                                    //self.cannonLevelDownSpirt?.texture = self.levelDownTextureList![0]
                                    //self.texture = self.animateTextureList[0]
                                })
    }
    

    
    
    
    
}
