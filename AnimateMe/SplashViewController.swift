//
//  SplashViewController.swift
//  AnimateMe
//
//  Created by Igor Chernyshov on 18.12.2021.
//

import UIKit

final class SplashViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet var logoView: UIImageView!

	// MARK: - Lifecycle
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		pulsateLogo()
	}

	// MARK: - Animation
	private func pulsateLogo() {
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			self.moveLogoDown()
		}

		let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
		pulseAnimation.fromValue = 1.0
		pulseAnimation.toValue = 1.15
		pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		pulseAnimation.duration = 0.45
		pulseAnimation.repeatCount = 2
		pulseAnimation.autoreverses = true

		logoView.layer.add(pulseAnimation, forKey: nil)

		CATransaction.commit()
	}

	private func moveLogoDown() {
		CATransaction.begin()
		CATransaction.setCompletionBlock {
			self.performSegue(withIdentifier: "login", sender: nil)
		}

		let moveLogoAnimation = CABasicAnimation(keyPath: "position.y")
		moveLogoAnimation.fromValue = UIScreen.main.bounds.size.height / 2
		moveLogoAnimation.toValue = UIScreen.main.bounds.size.height - (logoView.frame.height / 1.3)
		moveLogoAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		moveLogoAnimation.duration = 1.0
		moveLogoAnimation.fillMode = .forwards
		moveLogoAnimation.isRemovedOnCompletion = false

		logoView.layer.add(moveLogoAnimation, forKey: nil)

		CATransaction.commit()
	}
}
