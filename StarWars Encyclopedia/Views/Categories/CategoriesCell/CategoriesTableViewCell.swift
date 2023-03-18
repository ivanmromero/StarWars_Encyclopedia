//
//  CategoryTableViewCell.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 08/10/2022.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var categoriesImage: UIImageView!
    @IBOutlet weak var categoriesName: UILabel!
    
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    //MARK: setups
    func setupCell() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.selectionStyle = .none
    }
    
    //MARK: override funcs
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
