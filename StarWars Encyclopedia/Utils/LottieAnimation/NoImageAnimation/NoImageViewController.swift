//
//  NoImageViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 30/01/2023.
//

import UIKit
import Lottie

class NoImageViewController: UIViewController {
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var noImageLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottieAnimation()
        setupNoImageLabel()
    }

    private func setupLottieAnimation() {
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
    private func setupNoImageLabel() {
        noImageLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setTopConstraint(topConstaint: Int) {
        noImageLabelTopConstraint.constant = CGFloat(topConstaint)
    }
}
