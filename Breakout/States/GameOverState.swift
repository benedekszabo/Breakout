//
//  GameOver.swift
//  BreakoutSpriteKitTutorial
//

import SpriteKit
import GameplayKit

class GameOverState: GameState {
  
  override func didEnter(from previousState: GKState?) {
    if previousState is PlayingState {
      let ball = scene.childNode(withName: BallCategoryIdentifier) as! SKSpriteNode
      ball.physicsBody!.linearDamping = 1.0
      scene.physicsWorld.gravity = CGVector(dx: 0, dy: -10)
    }
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is AwaitingTapState.Type
  }
  
}
