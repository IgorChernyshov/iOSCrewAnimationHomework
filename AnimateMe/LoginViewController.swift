//
//  ViewController.swift
//  AnimateMe
//
//  Created by katleta3000 on 21.11.2021.
//

import UIKit

final class LoginViewController: UIViewController {
	
	@IBOutlet var username: UITextField! {
		didSet {
			username.layer.borderColor = UIColor(named: "Purple")?.cgColor
			username.layer.borderWidth = 1
			username.alpha = 0.01
		}
	}

	@IBOutlet var password: UITextField! {
		didSet {
			password.layer.borderColor = UIColor(named: "Purple")?.cgColor
			password.layer.borderWidth = 1
			password.alpha = 0.01
		}
	}

	@IBOutlet var login: UIButton! {
		didSet {
			login.backgroundColor = UIColor(named: "Purple")
			login.layer.cornerRadius = 8
			login.alpha = 0.01
		}
	}

	@IBOutlet var activityIndicator: UIActivityIndicatorView! {
		didSet {
			activityIndicator.stopAnimating()
		}
	}

	private let loginService = Services.loginService

	@IBAction func clickedLogin() {
		login.isEnabled = false
		applySlideOutAnimation(to: login)
		activityIndicator.startAnimating()

		loginService.login(login: username.text ?? "", password: password.text ?? "") { success in
			self.activityIndicator.stopAnimating()

			if success {
				self.startFillScreenAnimation()
			} else {
				self.login.isEnabled = true
				self.applySlideInAnimation(to: self.login)
				self.applyShakeAnimation(to: self.username)
				self.applyShakeAnimation(to: self.password)
				let alert = UIAlertController(
					title: "Error", message: "Not correct login or password", preferredStyle: .alert
				)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				self.present(alert, animated: false, completion: nil)
			}
		}
	}

	// MARK: - Animations
	private func startFillScreenAnimation() {
		let fillerLayer = CALayer()
		fillerLayer.backgroundColor = UIColor(named: "Purple")?.cgColor
		fillerLayer.frame = CGRect(x: 0, y: -UIScreen.main.bounds.maxY, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY)
		view.layer.addSublayer(fillerLayer)

		CATransaction.begin()
		CATransaction.setCompletionBlock {
			self.performSegue(withIdentifier: "List", sender: nil)
		}
		let fillAnimation = CABasicAnimation(keyPath: "transform.translation.y")
		fillAnimation.fromValue = -UIScreen.main.bounds.maxY
		fillAnimation.toValue = UIScreen.main.bounds.maxY
		fillAnimation.duration = 1
		fillAnimation.fillMode = .forwards
		fillAnimation.isRemovedOnCompletion = false
		fillerLayer.add(fillAnimation, forKey: nil)
		CATransaction.commit()
	}

	private func applySlideOutAnimation(to slidingView: UIView) {
		CATransaction.begin()
		let slideAnimation = CABasicAnimation(keyPath: "position.x")
		slideAnimation.fromValue = slidingView.layer.position.x
		slideAnimation.toValue = UIScreen.main.bounds.maxX + slidingView.layer.position.x
		slideAnimation.fillMode = .forwards
		slideAnimation.isRemovedOnCompletion = false
		slidingView.layer.add(slideAnimation, forKey: nil)
		CATransaction.commit()
	}

	private func applySlideInAnimation(to slidingView: UIView) {
		CATransaction.begin()
		let slideAnimation = CABasicAnimation(keyPath: "position.x")
		slideAnimation.fromValue = UIScreen.main.bounds.minX - slidingView.layer.position.x
		slideAnimation.toValue = slidingView.layer.position.x
		slideAnimation.fillMode = .forwards
		slideAnimation.isRemovedOnCompletion = false
		slidingView.layer.add(slideAnimation, forKey: nil)
		CATransaction.commit()
	}

	private func applyShakeAnimation(to shakingView: UIView) {
		CATransaction.begin()
		let shakeAnimation = CABasicAnimation(keyPath: "position")
		shakeAnimation.duration = 0.07
		shakeAnimation.repeatCount = 4
		shakeAnimation.autoreverses = true
		shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: shakingView.center.x - 10, y: shakingView.center.y))
		shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: shakingView.center.x + 10, y: shakingView.center.y))

		shakingView.layer.add(shakeAnimation, forKey: "position")
		CATransaction.commit()
	}

	// MARK: - Lifecycle
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 1) {
			self.username.alpha = 1
			self.password.alpha = 1
			self.login.alpha = 1
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
}
