//
//  CoinSpirt.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/24.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

class CoinSpirt :SKSpriteNode,AfterAddToGameScene{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static private let coinTextureMap :[String:SKTexture] = [
        "coin1":SKTexture(imageNamed: "coinAni1"),
        "coin2":SKTexture(imageNamed: "coinAni2")
    ]
    
    static private let textTexture = SKTexture(imageNamed: "coinText")
    static private var textList:[SKTexture] = {
        var list = [SKTexture]()
        for i in 0...10{
            let texture = SKTexture(rect: CGRect(x: CGFloat(i)/CGFloat(11), y: 0, width: 1/CGFloat(11), height: 1),
                                    in: CoinSpirt.textTexture)
            list.append(texture)
        }
        return list
    }()
    
    private var animateTexture = [SKTexture]()
   
    
    var level :Int
    var multiple:Int
    var angle : CGFloat
    var score:Int{
        return (level == 1 ? 50 : 100)*multiple
    }
    
    init(level:Int,multiple:Int,at position:CGPoint,to endPoint:CGPoint){
        guard let fullTexture = CoinSpirt.coinTextureMap["coin\(level)"] else {
            fatalError("init() image coin\(level) not exiset")
        }
        self.level = level
        self.multiple = multiple
        let dx = endPoint.x - position.x
        let dy = endPoint.y - position.y
        angle = atan2(dx,dy)
                
        for i in 0...9{
            let texture = SKTexture(rect: CGRect(x: 0.0, y: CGFloat(i)/CGFloat(10), width: 1, height: 1/CGFloat(10)),
                                    in: fullTexture)
            animateTexture.append(texture)
        }
        super.init(texture: animateTexture[0], color: UIColor.clear, size: animateTexture[0].size())
        name = "coin"
        self.position = position
        zPosition = -2
        xScale = JoyFishConstant.Scale
        yScale = JoyFishConstant.Scale
    }
    
    deinit {
        //print("coin out")
    }
    
    
    func afterAddToScene() {
        let xSpirt = SKSpriteNode(texture: CoinSpirt.textList[10])
        xSpirt.position = position.offsetBy(dx: size.width, dy: 0)
        xSpirt.name = "x"
        xSpirt.xScale = JoyFishConstant.Scale
        xSpirt.yScale = JoyFishConstant.Scale
        
        let nSpirt = SKSpriteNode(texture: CoinSpirt.textList[multiple == 10 ? 1 : multiple])
        let oSpirt :SKSpriteNode?={
            multiple == 10 ? SKSpriteNode(texture: CoinSpirt.textList[0]) : nil
        }()
        nSpirt.position = xSpirt.position.offsetBy(dx: xSpirt.size.width, dy: 0)
        oSpirt?.position = nSpirt.position.offsetBy(dx: nSpirt.size.width/2, dy: 0)
        nSpirt.xScale = JoyFishConstant.Scale
        nSpirt.yScale = JoyFishConstant.Scale
        oSpirt?.xScale = JoyFishConstant.Scale
        oSpirt?.yScale = JoyFishConstant.Scale
        
        scene?.addChild(xSpirt)
        scene?.addChild(nSpirt)
        if let o = oSpirt{
            scene?.addChild(o)
        }
        
        let routeAnimate = SKAction.animate(with: animateTexture, timePerFrame: 0.15)
        let duration = TimeInterval(Int.max)
        let moveAction = SKAction.customAction(withDuration:duration,actionBlock:{ (node,elapsedTime)  in
            if let node = node as? SKSpriteNode{
                node.position.x += sin(self.angle) * 3
                node.position.y += cos(self.angle) * 3
                if node.position.x > (node.scene?.view?.bounds.width)!+10
                    || node.position.y > (node.scene?.view?.bounds.height)!
                    || node.position.x < -10
                    || node.position.y < 0 {
                    node.removeAction(forKey: "move")
                    node.removeAction(forKey: "route")
        
                    if let scene = self.scene as? GameScene{
                        scene.score?.score += self.score
                    }
                    node.removeFromParent()
               
                }
            }
        })
        run(routeAnimate, completion: {
            xSpirt.removeFromParent()
            oSpirt?.removeFromParent()
            nSpirt.removeFromParent()
            self.run(SKAction.repeatForever(routeAnimate), withKey: "route")
            self.run(moveAction, withKey: "move")
        })
    }
    
    
}
