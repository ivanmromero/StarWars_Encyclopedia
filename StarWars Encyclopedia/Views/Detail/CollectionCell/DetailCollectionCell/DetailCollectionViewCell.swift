//
//  DetailCollectionViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 01/11/2022.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryDetailImage: UIImageView!
    @IBOutlet weak var categoryDetailTitle: UILabel!
    @IBOutlet weak var categoryDetailSubtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryDetailImage.image = nil
    }
    
    private func setupCellView() {
        categoryDetailImage.layer.masksToBounds = true
        categoryDetailImage.layer.cornerRadius = 15
        categoryDetailImage.layer.borderWidth = 1
        categoryDetailImage.layer.borderColor = UIColor.white.cgColor
    }
}
