//
//  Constant.swift
//  joyFish
//
//  Created by 沈渝 on 2018/10/22.
//  Copyright © 2018 沈渝. All rights reserved.
//

import SpriteKit

public struct JoyFishConstant {
    static public let Scale: CGFloat = 0.4
    static public let fishCategoryBitMask :UInt32 = 0x1 << 3
    static public let bulletCategoryBitMask :UInt32 = 0x1 << 2
    static public let webCategoryBitMask :UInt32 = 0x1 << 1
    
    static public let fishzPosition:CGFloat = 1
    static public let bulletzPosition:CGFloat = 1
    static public let netzPosition:CGFloat = 2
    static public let backGroundzPosition:CGFloat = -100
    static public let backItemzPosition:CGFloat = 2
}
