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
    let manageData: ManageData
    
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
}
