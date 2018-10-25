//
//  extensionMageScence.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/17.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene{
    
    override func addChild(_ node: SKNode) {
        super.addChild(node)
        if let node = node as? AfterAddToGameScene{
            node.afterAddToScene()
        }
    }
    
    func initBackGround(_ view: SKView){
        //draw background
        let back = SKSpriteNode(imageNamed: "game_bg_2_hd")
        back.name = "back"
        back.anchorPoint = CGPoint(x:0,y:0)
        back.position = CGPoint(x:0,y:0)
        back.fullWithView(with: view)
        back.zPosition = JoyFishConstant.backGroundzPosition
        addChild(back)
        
        bar = SKSpriteNode(imageNamed: "bottom-bar")
        bar?.name = "bar"
        bar?.anchorPoint = CGPoint(x:0.553,y:0)
        bar?.position = CGPoint(x:view.bounds.width/2,y:-2)
        bar?.zPosition = -1
        bar?.xScale = 0.8
        bar?.yScale = 0.8
        addChild(bar!)
        
        //cannon
        let cannon = CannonSpirt(at: CGPoint(x:view.bounds.width/2,y:20))
        addChild(cannon)
        
        score = Score(bar:bar!)
        score?.score = 10000
        score?.scoreSpirts.forEach{ self.addChild($0) }
    }
    
    static let fishSequence=[1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,6,6,6,7,7,7,8,8,8,9,9,10,10,11];
    
    //static let fishSequence=[11];
    
    func initFishSpirt(){
        let index=GameScene.fishSequence[GameScene.fishSequence.count.arc4random]
        var fish:FishSprit?{
            switch index {
            case 1:
                return FishSprit(withImage: "fish1")
            case 2:
                return FishSprit(withImage: "fish2")
            case 3:
                return FishSprit(withImage: "fish3")
            case 4:
                return FishSprit(withImage: "fish4")
            case 5:
                return FishSprit(withImage: "fish5")
            case 6:
                return FishSprit(withImage: "fish6")
            case 7:
                return FishSprit(withImage: "fish7")
            case 8:
                return FishSprit(withImage: "fish8")
            case 9:
                return FishSprit(withImage: "fish9")
            case 10:
                return FishSprit(withImage: "fish10")
            case 11:
                return FishSprit(withImage: "shark1")
            default:
                return nil
            }
        }
        if let fish = fish{
            addChild(fish)
        }
    }
}

struct  Score {
    var score:Int = 10000 {
        didSet{
            var a = score%10,
                b = score%100-a,
                c = score%1000-b-a,
                d = score%10000-c-b-a,
                e = score%100000-d-c-b-a,
                f = score%1000000-e-d-c-b-a
            b/=10
            c/=100
            d/=1000
            e/=10000
            f/=100000
            scoreSpirts[5].texture = numberList[a]
            scoreSpirts[4].texture = numberList[b]
            scoreSpirts[3].texture = numberList[c]
            scoreSpirts[2].texture = numberList[d]
            scoreSpirts[1].texture = numberList[e]
            scoreSpirts[0].texture = numberList[f]
        }
    }
    var scoreSpirts = [SKSpriteNode]()
    var numberList = [SKTexture]()
    private let texture = SKTexture(imageNamed: "number")
    
    init(bar :SKSpriteNode) {
        for i in 0...9 {
            let texture = SKTexture(rect: CGRect(x: 0.0, y: CGFloat(i)/CGFloat(10), width: 1, height: 1/CGFloat(10)),
                                    in: self.texture)
            numberList.append(texture)
        }
        //numberList.reverse()
        for i in 0...5 {
            if i == 0{
                let spirt = SKSpriteNode(texture: numberList[0])
                spirt.anchorPoint = CGPoint(x:-0.2,y:-0.11)
                spirt.position = bar.position.offsetBy(dx: -bar.size.width*bar.anchorPoint.x+20*bar.anchorPoint.x, dy: 0)
                spirt.xScale = bar.xScale
                spirt.yScale = bar.yScale
                scoreSpirts.append(spirt)
            }else{
                let persp = scoreSpirts[i-1]
                let spirt = SKSpriteNode(texture: numberList[0])
                spirt.anchorPoint = CGPoint(x:-0.2,y:-0.11)
                spirt.position = persp.position.offsetBy(dx: 23*bar.xScale, dy: 0)
                spirt.xScale = bar.xScale
                spirt.yScale = bar.yScale
                scoreSpirts.append(spirt)
            }
            
        }
    }
}
