//
//  Helpers.swift
//  Breakout
//

import UIKit

func randomCGFloat(from: CGFloat, to: CGFloat) -> CGFloat {
	let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
	return (rand) * (to - from) + from
}

func randomDirection() -> CGFloat {
	let speedFactor: CGFloat = 2.0
	if randomCGFloat(from: 0.0, to: 100.0) >= 50 {
		return -speedFactor
	} else {
		return speedFactor
	}
}
