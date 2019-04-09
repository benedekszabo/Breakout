//
//  GameScene.swift
//  Breakout
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	lazy var gameState: GKStateMachine = GKStateMachine(states: [AwaitingTapState(scene: self), PlayingState(scene: self), GameOverState(scene: self)])
	
	var gameWon: Bool = false {
		didSet {
			let gameOverMessage = childNode(withName: GameMessageIdentifier) as! SKSpriteNode
			let textureName = gameWon ? "YouWin" : "GameOver"
			let texture = SKTexture(imageNamed: textureName)
			let actionSequence = SKAction.sequence([SKAction.setTexture(texture), SKAction.scale(to: 1.0, duration: 0.3)])
			
			gameOverMessage.run(actionSequence)
			
			run(gameWon ? GameWonSound : GameOverSound)
		}
	}
	
	var isPaddleBeingTapped = false

	override func didMove(to view: SKView) {
		super.didMove(to: view)
		
		let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
		borderBody.friction = 0
		self.physicsBody = borderBody
		
		physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
		physicsWorld.contactDelegate = self
		
		let ball = childNode(withName: BallCategoryIdentifier) as! SKSpriteNode
		
		let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
		let bottom = SKNode()
		bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
		addChild(bottom)
		
		let paddle = childNode(withName: PaddleCategoryIdentifier) as! SKSpriteNode
		
		ball.physicsBody!.categoryBitMask = BallCategoryMaskBit
		paddle.physicsBody!.categoryBitMask = PaddleCategoryMaskBit
		borderBody.categoryBitMask = BorderCategoryMaskBit
		bottom.physicsBody!.categoryBitMask = BottomCategoryMaskBit
		
		ball.physicsBody!.contactTestBitMask = PaddleCategoryMaskBit | BlockCategoryMaskBit | BottomCategoryMaskBit | BorderCategoryMaskBit
		
		let numberOfBlocks = 7
		let blockWidth = SKSpriteNode(imageNamed: "block").size.width
		let blockRowWidth = blockWidth * CGFloat(numberOfBlocks)
		let xCoordinateOffset = (frame.width - blockRowWidth) / 2
		
		for i in 0..<numberOfBlocks {
			let block = SKSpriteNode(imageNamed: "block.png")
			block.position = CGPoint(x: xCoordinateOffset + CGFloat(CGFloat(i) + 0.5) * blockWidth,
									 y: frame.height * 0.75)
			
			block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
			block.physicsBody!.isDynamic = false
			block.physicsBody!.affectedByGravity = false
			block.physicsBody!.allowsRotation = false
			block.physicsBody!.friction = 0.0
			block.name = BlockCategoryIdentifier
			block.physicsBody!.categoryBitMask = BlockCategoryMaskBit
			block.zPosition = 2
			addChild(block)
		}
		
		let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
		gameMessage.name = GameMessageIdentifier
		gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
		gameMessage.zPosition = 4
		gameMessage.setScale(0.0)
		addChild(gameMessage)
		
		gameState.enter(AwaitingTapState.self)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		switch gameState.currentState {
		case is AwaitingTapState:
			gameState.enter(PlayingState.self)
			isPaddleBeingTapped = true
			
		case is PlayingState:
			let touch = touches.first
			let touchLocation = touch!.location(in: self)
			
			if let body = physicsWorld.body(at: touchLocation) {
				if body.node!.name == PaddleCategoryIdentifier {
					isPaddleBeingTapped = true
				}
			}
			
		case is GameOverState:
			let newScene = GameScene(fileNamed: "GameScene")
			newScene!.scaleMode = .aspectFit
			let revealTransition = SKTransition.flipHorizontal(withDuration: 0.5)
			self.view?.presentScene(newScene!, transition: revealTransition)
			
		default:
			break
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if isPaddleBeingTapped {
			let touch = touches.first
			let currentTouchLocation = touch!.location(in: self)
			let previousTouchLocation = touch!.previousLocation(in: self)
			
			let paddle = childNode(withName: PaddleCategoryIdentifier) as! SKSpriteNode
			
			var paddleXCoordinate = paddle.position.x + (currentTouchLocation.x - previousTouchLocation.x)
			paddleXCoordinate = max(paddleXCoordinate, paddle.size.width/2)
			paddleXCoordinate = min(paddleXCoordinate, size.width - paddle.size.width/2)
			
			paddle.position = CGPoint(x: paddleXCoordinate, y: paddle.position.y)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		isPaddleBeingTapped = false
	}
	
	override func update(_ currentTime: TimeInterval) {
		gameState.update(deltaTime: currentTime)
	}
	
	func isGameWon() -> Bool {
		var numberOfBricks = 0
		self.enumerateChildNodes(withName: BlockCategoryIdentifier) {
			node, stop in
			numberOfBricks = numberOfBricks + 1
		}
		return numberOfBricks == 0
	}
	
}

extension GameScene: SKPhysicsContactDelegate {
	
	func didBegin(_ contact: SKPhysicsContact) {
		if gameState.currentState is PlayingState {
			var firstContactBody: SKPhysicsBody
			var secondContactBody: SKPhysicsBody
			
			if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
				firstContactBody = contact.bodyA
				secondContactBody = contact.bodyB
			} else {
				firstContactBody = contact.bodyB
				secondContactBody = contact.bodyA
			}
			
			if firstContactBody.categoryBitMask == BallCategoryMaskBit && secondContactBody.categoryBitMask == BottomCategoryMaskBit {
				gameState.enter(GameOverState.self)
				gameWon = false
			}
			
			if firstContactBody.categoryBitMask == BallCategoryMaskBit && secondContactBody.categoryBitMask == BlockCategoryMaskBit {
				run(BlockBreakSound)
				
				secondContactBody.node!.removeFromParent()
				if isGameWon() {
					gameState.enter(GameOverState.self)
					gameWon = true
				}
			}
			
			if firstContactBody.categoryBitMask == BallCategoryMaskBit && secondContactBody.categoryBitMask == PaddleCategoryMaskBit {
				run(PaddleBlipSound)
			}
			
			if firstContactBody.categoryBitMask == BallCategoryMaskBit && secondContactBody.categoryBitMask == BorderCategoryMaskBit {
				run(PongBlipSound)
			}
		}
	}
	
}
