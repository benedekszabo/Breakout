//
//  GameViewController.swift
//  Breakout
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let scene = GameScene(fileNamed:"GameScene") {
			let skView = self.view as! SKView
			skView.showsNodeCount = true
			skView.showsFPS = true
			
			scene.scaleMode = .aspectFit
		
			skView.ignoresSiblingOrder = true
			
			skView.presentScene(scene)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override var shouldAutorotate : Bool {
		return true
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}
	
}
