//
//  CategoryCollectionViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 09/10/2022.
//

import UIKit
import iProgressHUD

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    private let iprogress: iProgressHUD = iProgressHUD()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.setupSpinner()
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
//        setupSpinner()
    }
    
    func setupSpinner() {
        iprogress.captionSize = 25
        iprogress.isShowModal = false
        iprogress.isShowBox = false
        iprogress.isShowCaption = false
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = .ballRotateChase
        iprogress.indicatorSize = 100
        iprogress.alphaModal = 0.7
        iprogress.captionDistance = 10
        iprogress.indicatorColor = UIColor(named: "StarWarsColor")!
        iprogress.attachProgress(toView: categoryImage)
        categoryImage.showProgress()
    }
    
}
