//
//  fish.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/17.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Fish :Hashable{
    
    var  spritNode:SKSpriteNode!
    var  imageName:String
    
    
    var startPoint :CGPoint
    var endPoint :CGPoint
    
    weak var scene:GameScene?
    var categoryBitMask:UInt32 = 1
    
    private struct ImageInfo {
        var imageLenth:Int
        var swimmingLength:Int
        var deadLength:Int{ return imageLenth-swimmingLength }
    }
    
    private var info:ImageInfo? {
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
    
    public struct SpirtProperts {
        var baseSpeed:CGFloat
        var speedRange:CGFloat
        var captureProbability:CGFloat
        var coinLevel:Int
        var multiple :Int
        var speed:CGFloat{ return  baseSpeed + speedRange.arc4random}
    }
    
    public var propert:SpirtProperts?{
        switch imageName {
        case "shark1":
            return SpirtProperts(baseSpeed: 3, speedRange: 1.1, captureProbability: 0.01, coinLevel: 2,multiple:10)
        case "fish1":
            return SpirtProperts(baseSpeed: 1, speedRange: 2, captureProbability: 0.7, coinLevel: 1,multiple:1)
        case "fish2":
            return SpirtProperts(baseSpeed: 1, speedRange: 2, captureProbability: 0.6, coinLevel: 1,multiple:2)
        case "fish3":
            return SpirtProperts(baseSpeed: 1.5, speedRange: 2, captureProbability: 0.5, coinLevel: 1,multiple:3)
        case "fish4":
            return SpirtProperts(baseSpeed: 2, speedRange: 1, captureProbability: 0.4, coinLevel: 1,multiple:4)
        case "fish5":
            return SpirtProperts(baseSpeed: 1.2, speedRange: 2.1, captureProbability: 0.35, coinLevel: 1,multiple:5)
        case "fish6":
            return SpirtProperts(baseSpeed: 1.4, speedRange: 1, captureProbability: 0.3, coinLevel: 2,multiple:1)
        case "fish7":
            return SpirtProperts(baseSpeed: 1, speedRange: 4, captureProbability: 0.2, coinLevel: 2,multiple:2)
        case "fish8":
            return SpirtProperts(baseSpeed: 2.2, speedRange: 1, captureProbability: 0.15, coinLevel: 2,multiple:3)
        case "fish9":
            return SpirtProperts(baseSpeed: 1.2, speedRange: 3, captureProbability: 0.1, coinLevel: 2,multiple:4)
        case "fish10":
            return SpirtProperts(baseSpeed: 1, speedRange: 2, captureProbability: 0.05, coinLevel: 2,multiple:5)
        default:
            return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identify)
    }
    
    private var identify:UUID
    
    static func == (me:Fish,other:Fish)->Bool{
        return me.identify==other.identify
    }
    
    static private var textureMap = [String:SKTexture]()

    
    private var swimTextures = [SKTexture]()
    private var deadTextures = [SKTexture]()
    
    init(withImage imageName:String,showin scene:GameScene) {
        self.identify = UUID()
        self.imageName = imageName
        self.scene = scene
        if 2.arc4random == 1 {
            startPoint = CGPoint(x:-210,y:(scene.view?.bounds.height.arc4random)!)
            endPoint = CGPoint(x:(scene.view?.bounds.width)! + 220,y:(scene.view?.bounds.height.arc4random)!)
        }else{
            startPoint = CGPoint(x:(scene.view?.bounds.width)! + 210,y:(scene.view?.bounds.height.arc4random)!)
            endPoint = CGPoint(x: -220,y:(scene.view?.bounds.height.arc4random)!)
        }
        if let info = info {
            let fulltexture:SKTexture
            if let fullOp = Fish.textureMap[imageName]{
                fulltexture = fullOp
            }else{
                fulltexture = SKTexture(imageNamed: imageName)
                Fish.textureMap[imageName] = fulltexture
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
            spritNode = SKSpriteNode(texture: swimTextures[0])
            spritNode.xScale = 0.4
            spritNode.yScale = 0.4
            spritNode.anchorPoint = CGPoint(x:1,y:0.5)
            spritNode.position = self.startPoint
            spritNode.zPosition = 1
     
            spritNode.physicsBody = SKPhysicsBody(texture: spritNode.texture!, size: CGSize(width: spritNode.size.width, height: spritNode.size.height))
            spritNode.physicsBody?.isDynamic = false
            spritNode.physicsBody?.affectedByGravity = false
            spritNode.physicsBody?.categoryBitMask = categoryBitMask
            spritNode.physicsBody?.contactTestBitMask =  1
            spritNode.physicsBody?.collisionBitMask = 1
            
            spritNode.name = "fish"
            scene.addChild(spritNode)
            startSwim()
            move()
        }
    }
    
    func move() {
        let duration = TimeInterval(Int.max)
        let followPlayer = SKAction.customAction(withDuration:duration,actionBlock:{ (node,elapsedTime)  in
            if let node = node as? SKSpriteNode{
                let dx = self.endPoint.x - node.position.x
                let dy = self.endPoint.y - node.position.y
                let angle = atan2(dx,dy)
                node.position.x += sin(angle) * (self.propert?.speed)!
                node.position.y += cos(angle) * (self.propert?.speed)!
                node.zRotation = CGFloat.pi/2 - angle
            }
        })
        spritNode.run(followPlayer,withKey:"move")
    }
    
    func checkOut(){
        if spritNode.position.x > (scene?.view?.bounds.width)!+210
            || spritNode.position.y > (scene?.view?.bounds.height)!+210
            || spritNode.position.x < -210
            || spritNode.position.y < -210 {
            print("fish out!!!!!")
            spritNode.removeAction(forKey: "swim")
            spritNode.removeAction(forKey: "move")
            spritNode.removeFromParent()
            scene?.fishs.removeAll(where: { $0==self})
        }
    }
    
    public func startSwim(){
        let swimAction = SKAction.animate(with: swimTextures,timePerFrame: 0.15)
        spritNode.run(SKAction.repeatForever(swimAction), withKey: "swim")
    }
    
    public func dead(){
        spritNode.removeAction(forKey: "swim")
        spritNode.removeAction(forKey: "move")
        let deadAction = SKAction.animate(with: deadTextures, timePerFrame: 0.15)
        spritNode.run(SKAction.repeat(deadAction, count: 4),
                      completion: {
                        self.spritNode.removeFromParent()
                        self.scene?.fishs.removeAll(where: { $0==self})
                     }
        )
    }
    
}





