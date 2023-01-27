//
//  SectionCollectionTableViewCellViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 13/01/2023.
//

import Foundation
import UIKit

class CollectionTableViewCellViewModel {
    var sectionDataManage: SectionDataManage? = nil
    
    func getNumberOfCategories() -> Int {
        guard let sectionDataManage = sectionDataManage else { return 0 }
        return sectionDataManage.getResultsCount()
    }
    
    func getNameOrTitleAtIndex(index: Int) -> String {
        guard let sectionDataManage = sectionDataManage else { return "No hay nombre o titulo" }
        return sectionDataManage.getNameOrTitleAt(index)
    }
    
    func getSubtitleAt(_ index: Int) -> String {
        guard let sectionDataManage = sectionDataManage else { return "No hay subtitulo" }
        return sectionDataManage.getSubtitleAt(index)
    }
    
    func getImage(index: Int) -> UIImage? {
        guard let sectionDataManage = sectionDataManage else { return nil }
        return sectionDataManage.getImage(index)
    }
    
    func getData(completion: @escaping()->Void) {
        guard let sectionDataManage = sectionDataManage else { return completion() }
        sectionDataManage.getData {
            completion()
        }
    }
}
