//
//  DetailViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 24/10/2022.
//

import Foundation
import UIKit

class DetailViewModel {
    private let categoryDataManage: CategoryDataManage
    
    init(categoryDataManage: CategoryDataManage) {
        self.categoryDataManage = categoryDataManage
    }
    
    func getImage() -> UIImage? {
        categoryDataManage.getImageOfResultSelected()
    }
    
    func getNameOrTitle() -> String {
        categoryDataManage.getNameOrTitle()
    }
    
    func getSectionNameAt(index: Int) -> String {
        categoryDataManage.getNameOfSection(index: index)
    }
    
    func getCountOfSections() -> Int {
        categoryDataManage.getNumberOfSections()
    }
    
    func getInfo() -> [String: String]? {
        categoryDataManage.getInfoOfResultSelected()
    }
    
    func getSectionDataManage(index : Int) -> SectionDataManage? {
        categoryDataManage.getSectionDataManageAt(index)
    }
}
