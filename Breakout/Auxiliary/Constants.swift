//
//  Constants.swift
//  Breakout
//

import Foundation
import SpriteKit

let GameWonSound = SKAction.playSoundFileNamed("GameWonEffect", waitForCompletion: false)
let GameOverSound = SKAction.playSoundFileNamed("GameOverEffect", waitForCompletion: false)
let PongBlipSound = SKAction.playSoundFileNamed("PongBlipEffect", waitForCompletion: false)
let PaddleBlipSound = SKAction.playSoundFileNamed("PaddleBlipEffect", waitForCompletion: false)
let BlockBreakSound = SKAction.playSoundFileNamed("BlockBreakEffect", waitForCompletion: false)

let BallCategoryIdentifier 		= "ball"
let BlockCategoryIdentifier 	= "block"
let PaddleCategoryIdentifier 	= "paddle"
let GameMessageIdentifier 		= "message"

let BallCategoryMaskBit   : UInt32 = 0x1 << 0
let BottomCategoryMaskBit : UInt32 = 0x1 << 1
let BlockCategoryMaskBit  : UInt32 = 0x1 << 2
let PaddleCategoryMaskBit : UInt32 = 0x1 << 3
let BorderCategoryMaskBit : UInt32 = 0x1 << 4
