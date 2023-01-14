//
//  PeopleCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation
import UIKit

class PeopleCategory: ManageData {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    
    var result: People? = nil

    func getResults(completion: @escaping(Bool)->Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: "people")
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<People, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.result = result
                    result.results.enumerated().forEach { (index,result) in
                        self.imageCacheManager.setImageOnCache(result.url, key: result.name, request: self.request)
                    }
                    completion(false)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getResultsCount() -> Int {
        guard let result = result else { return 0 }
        return result.results.count
    }
    
    func getNameOrTitle(index: Int) -> String {
        guard let result = result else { return "No hay resultado" }
        let data = result.results
            return data[index].name
    }
    
    func getImage(index: Int) -> UIImage? {
        guard let result = result else { return nil }
        let data = result.results
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getSearchResultsCountFor(searchText: String) -> Int {
        guard let result = result else { return 0 }
        return result.results.filter{$0.name.lowercased().contains(searchText.lowercased())}.count
    }
    
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String) -> String? {
        guard let result = result else { return nil }
        let searchResults = result.results.filter{$0.name.lowercased().contains(searchText.lowercased())}
            print(result.results.filter{$0.name.lowercased().contains(searchText.lowercased())})
            print(searchResults[index].name)
            return searchResults[index].name
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String) -> UIImage? {
        guard let result = result else { return nil }
        let searchResults = result.results.filter{$0.name.lowercased().contains(searchText.lowercased())}
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
}
