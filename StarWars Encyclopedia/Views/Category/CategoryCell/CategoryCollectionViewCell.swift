//
//  CategoryCollectionViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 09/10/2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
    }
    
}
