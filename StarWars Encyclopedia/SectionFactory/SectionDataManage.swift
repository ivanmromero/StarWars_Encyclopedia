//
//  SectionDataManage.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 23/01/2023.
//

import Foundation
import UIKit

protocol SectionDataManage {
    var request: RequestManager { get }
    var imageCacheManager: ImageCacheManager { get }
    var sectionUrls: [String] { get }
    func getResultsCount() -> Int
    func getData(completion: @escaping()->Void)
    func getNameOrTitleAt(_ index: Int) -> String
    func getImage(_ index: Int) -> UIImage?
    func getSubtitleAt(_ index: Int) -> String
}
