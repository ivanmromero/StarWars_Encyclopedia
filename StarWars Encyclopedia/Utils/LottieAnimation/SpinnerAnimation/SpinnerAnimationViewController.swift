//
//  SpinnerAnimationViewController.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 22/02/2023.
//

import UIKit
import Lottie

class SpinnerAnimationViewController: UIViewController {
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottieAnimation()
    }
    
    private func setupLottieAnimation() {
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.animationSpeed = 1.5
        lottieAnimationView.play()
    }
    
    func addLottieAnimationToView(_ view: UIView) {
        if view.frame.size.height > view.frame.size.width {
            self.view.frame.size = CGSize(width: view.frame.size.width*0.7, height: view.frame.size.height)
            self.view.center = CGPoint(x: view.bounds.size.width  / 2, y: view.bounds.size.height  / 3)
        } else if view.frame.size.height < view.frame.size.width {
            self.view.frame.size = CGSize(width: view.frame.size.width / 2, height: view.frame.size.height)
            self.view.center = CGPoint(x: view.bounds.size.width  / 2, y: view.bounds.size.height  / 2)
        } else {
            self.view.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
            self.view.center = CGPoint(x: view.bounds.size.width  / 2, y: view.bounds.size.height  / 2)
        }
        
        view.addSubview(self.view)
    }
    
    func reomoveLottieAnimationToView(_ view: UIView) {
        view.subviews.forEach { subview in
            if subview.isDescendant(of: self.view) {
                subview.removeFromSuperview()
            }
        }
    }
}
