//
//  Playing.swift
//  BreakoutSpriteKitTutorial
//

import SpriteKit
import GameplayKit

class PlayingState: GameState {
  
  override func didEnter(from previousState: GKState?) {
    if previousState is AwaitingTapState {
      let ball = scene.childNode(withName: BallCategoryIdentifier) as! SKSpriteNode
      ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: randomDirection()))
    }
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    let ball = scene.childNode(withName: BallCategoryIdentifier) as! SKSpriteNode
    
    let maxSpeed: CGFloat = 500.0
    
    let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
    let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
    let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
    
    if xSpeed <= 10.0 {
      ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
    }
	
    if ySpeed <= 10.0 {
      ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
    }
    
    if speed > maxSpeed {
      ball.physicsBody!.linearDamping = 0.5
    } else {
      ball.physicsBody!.linearDamping = 0.0
    }
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameOverState.Type
  }
  
}
