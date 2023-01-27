//
//  CollectionTableViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 01/11/2022.
//

import UIKit
import iProgressHUD

class CollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UIView!
    
    private let iprogress: iProgressHUD = iProgressHUD()
    
    var viewModel: CollectionTableViewCellViewModel = CollectionTableViewCellViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.horizontalCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setuphorizontalCollection()
        setupImageSpinner()
    }
    
    private func setuphorizontalCollection() {
        horizontalCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionCell")
        horizontalCollectionView.dataSource = self
    }
    
    private func setupImageSpinner() {
        iprogress.isShowModal = false
        iprogress.isShowBox = false
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = .ballRotateChase
        iprogress.indicatorSize = 250
        iprogress.alphaModal = 0.7
        iprogress.captionDistance = 10
        iprogress.indicatorColor = UIColor(named: "StarWarsColor")!
        iprogress.attachProgress(toView: contentCollectionView)
        contentCollectionView.showProgress()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionCell", for: indexPath) as! DetailCollectionViewCell
        
            cell.categoryDetailTitle.text = viewModel.getNameOrTitleAtIndex(index: indexPath.row)
            cell.categoryDetailSubtitle.text = viewModel.getSubtitleAt(indexPath.row)
            if let image = viewModel.getImage(index: indexPath.row) {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        cell.categoryDetailImage.image = image
                    }
                }
            }
            contentCollectionView.dismissProgress()
        
        return cell
    }
}
