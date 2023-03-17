//
//  CollectionTableViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 01/11/2022.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UIView!
    
    private let spinnerAnimation: SpinnerAnimationViewController = SpinnerAnimationViewController()
    
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
        spinnerAnimation.addLottieAnimationToView(self.contentView)
    }
    
    private func setuphorizontalCollection() {
        horizontalCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionCell")
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.indicatorStyle = .white
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
            DispatchQueue.main.async {
                cell.categoryDetailImage.image = image
            }
        } else {
            cell.addLottieViewOnCategoryImage()
        }
        spinnerAnimation.reomoveLottieAnimationToView(self.contentView)
        
        return cell
    }
}
