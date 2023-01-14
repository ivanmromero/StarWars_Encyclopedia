//
//  CollectionTableViewCellViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 13/01/2023.
//

import Foundation

class CollectionTableViewCellViewModel {
    let categoryArray: [String]
    
    init(categoryArray: [String]) {
        self.categoryArray = categoryArray
    }
    
    func getNumberOfCategories() -> Int {
        return categoryArray.count
    }
}
