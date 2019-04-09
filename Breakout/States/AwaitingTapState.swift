//
//  WaitingForTap.swift
//  BreakoutSpriteKitTutorial
//

import SpriteKit
import GameplayKit

class AwaitingTapState: GameState {
  
  override func didEnter(from previousState: GKState?) {
    let scale = SKAction.scale(to: 1.0, duration: 0.25)
    scene.childNode(withName: GameMessageIdentifier)!.run(scale)
  }
  
  override func willExit(to nextState: GKState) {
    if nextState is PlayingState {
      let scale = SKAction.scale(to: 0, duration: 0.4)
      scene.childNode(withName: GameMessageIdentifier)!.run(scale)
    }
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is PlayingState.Type
  }

}
