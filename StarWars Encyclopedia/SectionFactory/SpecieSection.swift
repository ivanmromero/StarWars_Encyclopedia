//
//  SpecieSection.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 24/01/2023.
//

import Foundation
import UIKit

class SpecieSection: SectionDataManage {
    let sectionUrls: [String]
    let request: RequestManager
    let imageCacheManager: ImageCacheManager
    
    var result: [SpeciesResult] = []
    
    init(sectionUrls: [String], request: RequestManager, imageCacheManager: ImageCacheManager) {
        self.sectionUrls = sectionUrls
        self.request = request
        self.imageCacheManager = imageCacheManager
    }
    
    func getData(completion: @escaping(Bool)->Void) {
        let downloadGroup: DispatchGroup = DispatchGroup()
        var results = [SpeciesResult?](repeating: nil, count: sectionUrls.count)
        
        DispatchQueue.concurrentPerform(iterations: sectionUrls.count) { index in
            let url = URL(string: sectionUrls[index])
            
            downloadGroup.enter()
            self.request.makeRequest(url: url) { [weak self] (result: Result<SpeciesResult,Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    results[index] = result
                    self.imageCacheManager.setImageOnCache(result.url, key: result.name, request: self.request, typeOfCategory: .species)
                    downloadGroup.leave()
                    completion(false)
                case .failure(let error):
                    print(error)
                    completion(true)
                }
            }
        }
        
        downloadGroup.notify(queue: .main) {
            print("Termino la tarea de descarga de la seccion species")
            self.result = results.compactMap({ $0 })
        }
    }
    
    func getNameOrTitleAt(_ index: Int) -> String {
        return result[index].name
    }
    
    func getSubtitleAt(_ index: Int) -> String {
        return result[index].classification
    }
    
    func getImage(_ index: Int) -> UIImage? {
        return imageCacheManager.imageCache.object(forKey: result[index].name as AnyObject) as? UIImage
    }
    
    func getResultsCount() -> Int {
        return result.count
    }
}
