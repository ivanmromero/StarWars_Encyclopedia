//
//  SpeciesCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 16/01/2023.
//

import Foundation
import UIKit

class SpeciesCategory: CategoryDataManage {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    
    var speciesResults: [SpeciesResult] = []
    var searchResults: [SpeciesResult]?
    var resultSelected: SpeciesResult?
    var nextPage: String?
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue(label: "com.queue.speciesSerial", qos: .userInteractive).async {
            let dowloadGroup: DispatchGroup = DispatchGroup()
            var url: URL?
            
            if let next = self.nextPage {
                url = URL(string: next)
            } else {
                url = self.request.getURL(valueCategoryPath: Categories.species.rawValue)
            }
            
            dowloadGroup.enter()
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Species, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.speciesResults.append(contentsOf: result.results)
                    DispatchQueue.concurrentPerform(iterations: result.results.count) { index in
                        self.imageCacheManager.setImageOnCache(result.results[index].url, key: result.results[index].name, request: self.request, typeOfCategory: .species)
                    }
                    
                    self.nextPage = result.next
                    if self.nextPage != nil {
                        self.getResults { isLoading in
                            dowloadGroup.leave()
                            completion(isLoading)
                        }
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            dowloadGroup.notify(queue: .main) {
                print("Tarea de descargas de categoria species terminada")
            }
        }
    }
    
    func getResultsCount() -> Int {
        return speciesResults.count
    }
    
    func getNameOrTitle(index: Int) -> String {
        let data = speciesResults
        return data[index].name
    }
    
    func getSearchResultsCountFor(searchText: String?) -> Int {
        guard let searchResults = searchResults else { return 0 }
        return searchResults.count
    }
    
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String? {
        guard let searchResults = searchResults else { return nil }
        print(searchResults)
        print(searchResults[index].name)
        return searchResults[index].name
    }
    
    func getImage(index: Int) -> UIImage? {
        let data = speciesResults
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let searchResults = searchResults else { return nil }
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
    
    func setSearchResults(searchText: String) {
        self.searchResults = speciesResults.filter{$0.name.lowercased().contains(searchText.lowercased())}
    }
    
    func setResultSelectedAt(index: Int) {
        resultSelected = speciesResults[index]
    }
    
    func setResultSelectedForSearchAt(index: Int) {
        guard let searchResults = searchResults else { return }
        resultSelected = searchResults[index]
    }
    
    func getImageOfResultSelected() -> UIImage? {
        guard let resultSelected = resultSelected else { return nil }
        return self.imageCacheManager.imageCache.object(forKey: resultSelected.name as AnyObject) as? UIImage
    }
    
    func getNameOrTitle() -> String {
        guard let resultSelected = resultSelected else { return "No hay resultado seleccionado" }
        return resultSelected.name
    }
    
    func getNameOfSection(index: Int) -> String {
        getSectionsOfSpecies()[index - 1]
    }
    
    private func getSectionsOfSpecies() -> [String]{
        let codingKeys = SpeciesResult.CodingKeys.self
        var sections: [String] = []
        
        if !(resultSelected!.films.isEmpty) {
            sections.append(codingKeys.films.rawValue)
        }
        
        if !(resultSelected!.people.isEmpty) {
            sections.append(codingKeys.people.rawValue)
        }
        
        return sections
    }
    
    func getNumberOfSections() -> Int { getSectionsOfSpecies().count + 1 }
    
    func getInfoOfResultSelected() -> [String : String]? {
        getSpeciesInfo()
    }
    
    private func getSpeciesInfo() -> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = SpeciesResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary["\(codingKeys.classification.rawValue):"] = resultSelected.classification
        dictionary["\(codingKeys.designation.rawValue):"] = resultSelected.designation.rawValue
        dictionary["\(codingKeys.averageHeight.rawValue):"] = resultSelected.averageHeight
        dictionary["\(codingKeys.skinColors.rawValue):"] = resultSelected.skinColors
        dictionary["\(codingKeys.hairColors.rawValue):"] = resultSelected.hairColors
        dictionary["\(codingKeys.skinColors.rawValue):"] = resultSelected.eyeColors
        dictionary["\(codingKeys.language.rawValue):"] = resultSelected.language
        dictionary["\(codingKeys.averageLifespan.rawValue):"] = resultSelected.averageLifespan
        
        return dictionary
    }
    
    func getSectionDataManageAt(_ index: Int) -> SectionDataManage? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = SpeciesResult.CodingKeys.self
        var urls: [String] = []
        var type: Categories
        
        let section = getSectionsOfSpecies()[index-1]
        
        switch section {
        case codingKeys.films.rawValue:
            type = .films
            urls = resultSelected.films
        case codingKeys.people.rawValue:
            type = .people
            urls = resultSelected.people
        default:
            return nil
        }
        return SectionDataManageFactory.builder(type: type, urls: urls, request: self.request, imageCacheManager: self.imageCacheManager)
    }
}
