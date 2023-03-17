//
//  CategoryViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 11/10/2022.
//

import Foundation
import UIKit

class CategoryViewModel {
    private let categoryDataManage: CategoryDataManage
    
    var searchText: String? {
        didSet {
            if searchText!.isEmpty {
                isSearching = false
            } else {
                isSearching = true
                categoryDataManage.setSearchResults(searchText: searchText!)
            }
        }
    }
    
    var isSearching: Bool = false
    var isLoading: Bool = true
    
    init(categoryDataManage: CategoryDataManage) {
        self.categoryDataManage = categoryDataManage
    }
    
    func getData(completion: @escaping ()->Void) {
        categoryDataManage.getResults { isTrue in
            self.isLoading = isTrue
            completion()
        }
    }
    
    func getResultsCount() -> Int {
        categoryDataManage.getResultsCount()
    }
    
    func getNameOrTitleAt(_ index: Int) -> String {
        categoryDataManage.getNameOrTitle(index: index)
    }
    
    func getSearchCountFor(_ searchText: String?) -> Int {
        categoryDataManage.getSearchResultsCountFor(searchText: searchText)
    }
    
    func getNameOrTitleOfSearchAt(_ index: Int, searchText: String?) -> String? {
        categoryDataManage.getNameOrTitleOfSearchResultAt(index, searchText: searchText)
    }
    
    func getImageAt(_ index: Int) -> UIImage? {
        categoryDataManage.getImage(index: index)
    }
    
    func getImageOfSearchAt(index: Int, Text: String?) -> UIImage? {
        categoryDataManage.getImageOfSearchResultAt(index: index, searchText: Text)
    }
    
    func setSelectedResultAt(_ index: Int) {
        if isSearching {
            categoryDataManage.setResultSelectedForSearchAt(index: index)
        } else {
            categoryDataManage.setResultSelectedAt(index: index)
        }
    }
    
    func getCategoryDataManage() -> CategoryDataManage {
        categoryDataManage
    }
    
    func getSingularCategoryRawValue() -> String {
        categoryDataManage.getCategorySelectedSingularRawValue()
    }
    
    func getCategoryRawValue() -> String {
        categoryDataManage.getCategorySelectedRawValue()
    }
}
