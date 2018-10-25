//
//  FishSpirt.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/20.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

class FishSprit :SKSpriteNode,AfterAddToGameScene{
    
    var imageName:String
    
    var property :FishSpirtProperty
    
    private var onLeft = 2.arc4random == 1 ? true : false
    lazy var startPoint :CGPoint = {
        if onLeft {
            return  CGPoint(x:-210,y:(scene?.view?.bounds.height.arc4random)!)
        }else{
            return CGPoint(x:(scene?.view?.bounds.width)! + 210,y:(scene?.view?.bounds.height.arc4random)!)
        }
    }()
    lazy var endPoint :CGPoint = {
        if self.onLeft {
            return CGPoint(x:(scene?.view?.bounds.width)! + 220,y:(scene?.view?.bounds.height.arc4random)!)
        }else{
            return CGPoint(x: -220,y:(scene?.view?.bounds.height.arc4random)!)
        }
    }()
    
    
    static private var textureMap = [String:SKTexture]()
    
    
    private var swimTextures = [SKTexture]()
    private var deadTextures = [SKTexture]()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(withImage imageName:String){
        guard let info = ImageInfo.getInfo(imageName: imageName),let property = FishSpirtProperty.getProperty(imageName: imageName) else{
            return nil
        }
        self.property = property
        self.imageName = imageName
        let fulltexture:SKTexture
        if let fullOp = FishSprit.textureMap[imageName]{
            fulltexture = fullOp
        }else{
            fulltexture = SKTexture(imageNamed: imageName)
            FishSprit.textureMap[imageName] = fulltexture
        }
        for  i in 0...info.deadLength-1{
            let texture = SKTexture(rect: CGRect(x: 0.0, y: CGFloat(i)/CGFloat(info.imageLenth), width: 1, height: 1/CGFloat(info.imageLenth)),
                                    in: fulltexture)
            deadTextures.append(texture)
        }
        for i in info.deadLength...info.imageLenth-1{
            let texture = SKTexture(rect: CGRect(x: 0.0, y: CGFloat(i)/CGFloat(info.imageLenth), width: 1, height: 1/CGFloat(info.imageLenth)),
                                    in: fulltexture)
            swimTextures.append(texture)
        }
        super.init(texture: swimTextures[0], color: UIColor.clear, size: swimTextures[0].size())
        name = "fish"
        xScale = JoyFishConstant.Scale
        yScale = JoyFishConstant.Scale
        //anchorPoint = CGPoint(x:1,y:0.5)
        //position = self.startPoint
        zPosition = JoyFishConstant.fishzPosition
        
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = JoyFishConstant.fishCategoryBitMask
        physicsBody?.collisionBitMask = 0
        //physicsBody?.contactTestBitMask = JoyFishConstant.bulletCategoryBitMask | JoyFishConstant.webCategoryBitMask
    }
    
    deinit {
        print("fish out!!")
    }
    
    public func dead(){
        physicsBody = nil
        removeAction(forKey: "swim")
        removeAction(forKey: "move")
        let deadAction = SKAction.animate(with: deadTextures, timePerFrame: 0.15)
        run(SKAction.repeat(deadAction, count: 4),
                      completion: {
                        if let scene = self.scene as? GameScene{
                            let endPoint = CGPoint(x:(scene.view?.bounds.width)!/2-(scene.bar?.size.width)!/2+20,y:0)
                            let coin = CoinSpirt(level: self.property.coinLevel, multiple: self.property.multiple, at: self.position,to:endPoint)
                            self.scene?.addChild(coin)
                        }
                        self.removeFromParent()
                      }
        )
    }
    
    public func afterAddToScene(){
        position = startPoint
        let swimAction = SKAction.animate(with: swimTextures,timePerFrame: 0.15)
        run(SKAction.repeatForever(swimAction), withKey: "swim")
        let duration = TimeInterval(Int.max)
        let moveAction = SKAction.customAction(withDuration:duration,actionBlock:{ (node,elapsedTime)  in
            if let node = node as? SKSpriteNode{
                let dx = self.endPoint.x - node.position.x
                let dy = self.endPoint.y - node.position.y
                let angle = atan2(dx,dy)
                node.position.x += sin(angle) * self.property.speed
                node.position.y += cos(angle) * self.property.speed
                node.zRotation = CGFloat.pi/2 - angle
                
                if node.position.x > (node.scene?.view?.bounds.width)!+210
                    || node.position.y > (node.scene?.view?.bounds.height)!+210
                    || node.position.x < -210
                    || node.position.y < -210 {
                    node.removeAction(forKey: "move")
                    node.removeAction(forKey: "swim")
                    node.removeFromParent()
                }                
            }
        })
        run(moveAction,withKey:"move")
    }
    
}

fileprivate  struct ImageInfo {
    var imageLenth:Int
    var swimmingLength:Int
    var deadLength:Int{ return imageLenth-swimmingLength }
    
    static func getInfo(imageName:String) ->ImageInfo?{
        switch imageName {
        case "shark1":
            return ImageInfo(imageLenth: 12, swimmingLength: 8)
        case "fish1":
            return ImageInfo(imageLenth: 8, swimmingLength: 4)
        case "fish2":
            return ImageInfo(imageLenth: 8, swimmingLength: 4)
        case "fish3":
            return ImageInfo(imageLenth: 8, swimmingLength: 4)
        case "fish4":
            return ImageInfo(imageLenth: 8, swimmingLength: 4)
        case "fish5":
            return ImageInfo(imageLenth: 8, swimmingLength: 4)
        case "fish6":
            return ImageInfo(imageLenth: 12, swimmingLength: 8)
        case "fish7":
            return ImageInfo(imageLenth: 10, swimmingLength: 6)
        case "fish8":
            return ImageInfo(imageLenth: 12, swimmingLength: 8)
        case "fish9":
            return ImageInfo(imageLenth: 12, swimmingLength: 8)
        case "fish10":
            return ImageInfo(imageLenth: 10, swimmingLength: 6)
        default:
            return nil
        }
    }
}

struct FishSpirtProperty {
    var baseSpeed:CGFloat
    var speedRange:CGFloat
    var captureProbability:CGFloat
    var coinLevel:Int
    var multiple :Int
    var speed:CGFloat{ return  baseSpeed + speedRange.arc4random}
    
    static func getProperty(imageName:String)->FishSpirtProperty?{
        switch imageName {
        case "shark1":
            return FishSpirtProperty(baseSpeed: 3, speedRange: 1.1, captureProbability: 0.05, coinLevel: 2,multiple:10)
        case "fish1":
            return FishSpirtProperty(baseSpeed: 1, speedRange: 2, captureProbability: 0.7, coinLevel: 1,multiple:1)
        case "fish2":
            return FishSpirtProperty(baseSpeed: 1, speedRange: 2, captureProbability: 0.6, coinLevel: 1,multiple:2)
        case "fish3":
            return FishSpirtProperty(baseSpeed: 1.5, speedRange: 2, captureProbability: 0.5, coinLevel: 1,multiple:3)
        case "fish4":
            return FishSpirtProperty(baseSpeed: 2, speedRange: 1, captureProbability: 0.4, coinLevel: 1,multiple:4)
        case "fish5":
            return FishSpirtProperty(baseSpeed: 1.2, speedRange: 2.1, captureProbability: 0.35, coinLevel: 1,multiple:5)
        case "fish6":
            return FishSpirtProperty(baseSpeed: 1.4, speedRange: 1, captureProbability: 0.3, coinLevel: 2,multiple:1)
        case "fish7":
            return FishSpirtProperty(baseSpeed: 1, speedRange: 4, captureProbability: 0.25, coinLevel: 2,multiple:2)
        case "fish8":
            return FishSpirtProperty(baseSpeed: 2.2, speedRange: 1, captureProbability: 0.2, coinLevel: 2,multiple:3)
        case "fish9":
            return FishSpirtProperty(baseSpeed: 1.2, speedRange: 3, captureProbability: 0.15, coinLevel: 2,multiple:4)
        case "fish10":
            return FishSpirtProperty(baseSpeed: 1, speedRange: 2, captureProbability: 0.1, coinLevel: 2,multiple:5)
        default:
            return nil
        }
    }
    
    
}


