//
//  extension.swift
//  flyBird
//
//  Created by 沈渝 on 2018/10/17.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit

extension SKSpriteNode{
    func fullWithView(with view:SKView){
        self.xScale = view.bounds.width/self.size.width
        self.yScale = view.bounds.height/self.size.height
        print("back scale",self.size.width,self.size.height)
    }
}

extension Int{
    var arc4random:Int{
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}


extension Collection{
    var onlyOne:Element?{
        return count == 1 ? first:nil
    }
}



import UIKit
extension CGRect{
    var leftHalf:CGRect {
        return CGRect(x:minX,y:minY,width:width/2,height:height)
    }
    var rightHalf:CGRect {
        return CGRect(x:midX,y:minY,width:width/2,height:height)
    }
    func inset(by size:CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size:CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale:CGFloat) -> CGRect {
        return insetBy(dx: (width-width*scale)/2, dy: (height-height*scale)/2)
    }
}

extension CGPoint{
    func offsetBy(dx:CGFloat,dy:CGFloat) -> CGPoint {
        return CGPoint(x:x+dx,y:y+dy)
    }
}

extension CGFloat{
    var arc4random:CGFloat{
        var floatValue = Float(self)
        let intValue = Int(floatValue*10000)
        var randomInt=0
        if intValue > 0 {
            randomInt = Int(arc4random_uniform(UInt32(intValue)))
        }else if intValue < 0{
            randomInt = -Int(arc4random_uniform(UInt32(abs(intValue))))
        }else {
            return 0.0
        }
        floatValue = Float(randomInt) / 10000
        return CGFloat(floatValue)
    }
}
