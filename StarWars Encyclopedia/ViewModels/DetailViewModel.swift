//
//  DetailViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 24/10/2022.
//

import Foundation
import UIKit

class DetailViewModel {
    private let manageData: ManageData
    
    init(manageData: ManageData) {
        self.manageData = manageData
    }
    
    func getImage() -> UIImage? {
        manageData.getImageOfResultSelected()
    }
    
    func getNameOrTitle() -> String {
        manageData.getNameOrTitle()
    }
    
    func getSectionNameAt(index: Int) -> String {
        manageData.getNameOfSection(index: index)
    }
    
    func getCountOfSections() -> Int {
        manageData.getNumberOfSections()
    }
    
    func getInfo() -> [String: String]? {
        manageData.getInfoOfResultSelected()
    }
    
    func getSectionDataAt(index: Int) -> [String]? {
        manageData.getSectionValuesAt(index: index)
    }
}
