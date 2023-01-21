//
//  CategoryViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 11/10/2022.
//

import Foundation
import UIKit

class CategoryViewModel {
    private let category: Categories
    private let requestHandler: RequestHandler
    private let manageData: ManageData
    
    var searchText: String? {
        didSet {
            if searchText!.isEmpty {
                isSearching = false
            } else {
                isSearching = true
            }
        }
    }
    
    var isSearching: Bool = false
    var isLoading: Bool = true
    
    init() {
        self.requestHandler = RequestHandler()
        self.category = CategoryManager.shared.category!
        self.manageData = ManageDataFactory.buildManageData(typeCategory: self.category)
    }
    
    func getData(completion: @escaping ()->Void) {
        manageData.getResults { isTrue in
            self.isLoading = isTrue
            print(self.requestHandler.imageDictionary)
            completion()
        }
    }
    
    func getResultsCount() -> Int {
        manageData.getResultsCount()
    }
    
    func getNameOrTitleAt(_ index: Int) -> String {
        manageData.getNameOrTitle(index: index)
    }
    
    func getSearchCountFor(_ searchText: String?) -> Int {
        manageData.getSearchResultsCountFor(searchText: searchText)
    }
    
    func getNameOrTitleOfSearchAt(_ index: Int, searchText: String?) -> String? {
        manageData.getNameOrTitleOfSearchResultAt(index, searchText: searchText)
    }
    
    func getImageAt(_ index: Int) -> UIImage? {
        manageData.getImage(index: index)
    }
    
    func getImageOfSearchAt(index: Int, Text: String?) -> UIImage? {
        manageData.getImageOfSearchResultAt(index: index, searchText: Text)
    }
    
    func setSelectedResultAt(_ index: Int) {
        manageData.setResultSelectedAt(index: index)
    }
    
    func getManageData() -> ManageData {
        manageData
    }
}
