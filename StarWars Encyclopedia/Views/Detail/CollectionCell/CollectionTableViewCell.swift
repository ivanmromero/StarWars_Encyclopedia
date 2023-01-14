//
//  CollectionTableViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 01/11/2022.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    var viewModel: CollectionTableViewCellViewModel = CollectionTableViewCellViewModel(categoryArray: []) {
        didSet {
            horizontalCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setuphorizontalCollection()
    }
    
    private func setuphorizontalCollection() {
        horizontalCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionCell")
        horizontalCollectionView.dataSource = self
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
        
        
        return cell
    }
}
