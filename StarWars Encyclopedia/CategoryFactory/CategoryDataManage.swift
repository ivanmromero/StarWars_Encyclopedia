//
//  CategoryDataManage.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation
import UIKit

protocol CategoryDataManage {
    var request: RequestManager { get }
    var imageCacheManager: ImageCacheManager { get }
    func getResults(completion: @escaping(Bool)->Void)
    func getResultsCount() -> Int
    func getNameOrTitle(index: Int) -> String
    func getSearchResultsCountFor(searchText: String?) -> Int
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String?
    func getImage(index: Int) -> UIImage?
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage?
    func setResultSelectedAt(index: Int)
    func getImageOfResultSelected() -> UIImage?
    func getNameOrTitle() -> String
    func getNameOfSection(index: Int) -> String
    func getNumberOfSections() -> Int
    func getInfoOfResultSelected() -> [String: String]?
    func getSectionDataManageAt(_ index: Int) -> SectionDataManage?
}
