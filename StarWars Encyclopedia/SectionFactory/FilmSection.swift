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
    let downloadGroup: DispatchGroup = DispatchGroup()

    var result: [FilmResult] = []
    
    init(sectionUrls: [String], request: RequestManager, imageCacheManager: ImageCacheManager) {
        self.sectionUrls = sectionUrls
        self.request = request
        self.imageCacheManager = imageCacheManager
    }
    
    func getData(completion: @escaping(Bool)->Void) {
        let downloadGroup: DispatchGroup = DispatchGroup()
        var results = [FilmResult?](repeating: nil, count: sectionUrls.count)
        
        DispatchQueue.concurrentPerform(iterations: sectionUrls.count) { index in
            let url = URL(string: sectionUrls[index])
            
            downloadGroup.enter()
            self.request.makeRequest(url: url) { [weak self] (result: Result<FilmResult,Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    results[index] = result
                    self.imageCacheManager.setImageOnCache(result.url, key: result.title, request: self.request, typeOfCategory: .films)
                    downloadGroup.leave()
                    completion(false)
                case .failure(let error):
                    print(error)
                    completion(true)
                }
            }
        }
        
        downloadGroup.notify(queue: .main) {
            print("Termino la tarea de descarga de la seccion films")
            self.result = results.compactMap({ $0 })
        }
    }
    
    func getNameOrTitleAt(_ index: Int) -> String {
        return result[index].title
    }
    
    func getSubtitleAt(_ index: Int) -> String {
        return result[index].director
    }
    
    func getImage(_ index: Int) -> UIImage? {
        return imageCacheManager.imageCache.object(forKey: result[index].title as AnyObject) as? UIImage
    }
    
    func getResultsCount() -> Int {
        return result.count
    }
}
