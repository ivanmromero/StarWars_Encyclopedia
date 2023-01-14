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
    func getResultsCount() -> Int
    func getResults(completion: @escaping(Bool)->Void)
    func getNameOrTitle(index: Int) -> String
    func getImage(index: Int) -> UIImage?
    func getSearchResultsCountFor(searchText: String) -> Int
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String) -> String?
    func getImageOfSearchResultAt(index: Int, searchText: String) -> UIImage?
}
