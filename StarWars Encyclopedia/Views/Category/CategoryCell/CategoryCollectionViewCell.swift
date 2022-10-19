//
//  CategoryCollectionViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 09/10/2022.
//

import UIKit
import iProgressHUD

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    private let iprogress: iProgressHUD = iProgressHUD()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellView()
        DispatchQueue.main.async {
            self.setupImageSpinner()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
    }
    
    private func setupImageSpinner() {
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
    
    private func setupCellView() {
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = 15
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.white.cgColor
    }
}
