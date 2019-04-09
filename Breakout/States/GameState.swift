//
//  GameState.swift
//  Breakout
//

import GameplayKit

class GameState: GKState {
	
	unowned let scene: GameScene
	
	required init(scene: SKScene) {
		self.scene = scene as! GameScene
		super.init()
	}
	
}
