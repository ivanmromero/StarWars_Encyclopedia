//
//  CategoryCollectionViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 09/10/2022.
//

import UIKit
import Lottie

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var noImageView: UIView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
        categoryImage.subviews.forEach { subview in
            if let noImageView = noImageView {
                if subview.isDescendant(of: noImageView ) {
                    subview.removeFromSuperview()
                    self.noImageView = nil
                }
            }
        }
    }
    
    private func setupCellView() {
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = 15
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.white.cgColor
    }
    
    func  addLottieViewOnCategoryImage() {
        let noImageAnimation = NoImageViewController()
        noImageAnimation.view.frame = categoryImage.frame
        noImageView = noImageAnimation.view
        categoryImage.addSubview(noImageAnimation.view)
    }
    
}
