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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottieAnimation()
    }

    private func setupLottieAnimation() {
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
}
