//
//  ManageData.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation
import UIKit

protocol ManageData {
    var request: RequestManager { get }
    var imageCacheManager: ImageCacheManager { get }
    func getResults(completion: @escaping(Bool)->Void)
    func getResultsCount() -> Int
    func getNameOrTitle(index: Int) -> String
    func getSearchResultsCountFor(searchText: String?) -> Int
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String?
    func getImage(index: Int) -> UIImage?
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage?
}
