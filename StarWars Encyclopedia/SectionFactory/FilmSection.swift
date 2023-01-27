//
//  FilmSection.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 23/01/2023.
//

import Foundation
import UIKit

class FilmSection: SectionDataManage {    
    let sectionUrls: [String]
    let request: RequestManager
    let imageCacheManager: ImageCacheManager

    
    var result: [FilmResult] = []
    
    init(sectionUrls: [String], request: RequestManager, imageCacheManager: ImageCacheManager) {
        self.sectionUrls = sectionUrls
        self.request = request
        self.imageCacheManager = imageCacheManager
    }
    
    func getData(completion: @escaping()->Void) {
        DispatchQueue.main.async {
            self.sectionUrls.forEach { url in
                let url = URL(string: url)
                self.request.makeRequest(url: url) { [weak self] (result: Result<FilmResult,Error>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let result):
                        self.result.append(result)
                        self.imageCacheManager.setImageOnCache(result.url, key: result.title, request: self.request, typeOfCategory: .films)
                        completion()
                    case .failure(let error):
                        print(error)
                        completion()
                    }
                }
            }
        }
    }
    
    func getNameOrTitleAt(_ index: Int) -> String {
        return result[index].title
    }
    
    func getSubtitleAt(_ index: Int) -> String {
        return result[index].producer
    }
    
    func getImage(_ index: Int) -> UIImage? {
        return imageCacheManager.imageCache.object(forKey: result[index].title as AnyObject) as? UIImage
    }
    
    func getResultsCount() -> Int {
        return result.count
    }
}
