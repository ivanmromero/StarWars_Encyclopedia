//
//  CategoriesViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 08/10/2022.
//

import UIKit

class CategoriesViewModel {
    func getAllCategories() -> [categories] {
        categories.allCases
    }
    
    func getCategoriesCount() -> Int {
        categories.allCases.count
    }
    
    func getSelectedCategory(indexPath: Int) -> categories {
        return getAllCategories()[indexPath]
    }
}
