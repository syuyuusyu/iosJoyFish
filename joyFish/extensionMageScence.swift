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
        back.anchorPoint = CGPoint(x:0,y:0)
        back.position = CGPoint(x:0,y:0)
        back.fullWithView(with: view)
        back.zPosition = JoyFishConstant.backGroundzPosition
        addChild(back)
        
        //cannon
        let cannon = CannonSpirt(at: CGPoint(x:view.bounds.width/2,y:20))
        addChild(cannon)
    }
    
    static let fishSequence=[1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,4,4,4,4,4,5,5,5,5,6,6,6,7,7,7,8,8,8,9,9,10,10,11];
    
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
