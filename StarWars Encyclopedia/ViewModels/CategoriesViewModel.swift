//
//  CategoriesViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 08/10/2022.
//

class CategoriesViewModel {
    func getAllCategories() -> [Categories] {
        Categories.allCases
    }
    
    func getCategoriesCount() -> Int {
        Categories.allCases.count
    }
    
    func getSelectedCategory(indexPath: Int) -> Categories {
        return getAllCategories()[indexPath]
    }
}
