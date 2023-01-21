//
//  SpeciesCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 16/01/2023.
//

import Foundation
import UIKit

class SpeciesCategory: ManageData {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    
    var result: Species?
    var resultSelected: SpeciesResult?
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.species.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Species, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.result = result
                    result.results.enumerated().forEach { (index,result) in
                        self.imageCacheManager.setImageOnCache(result.url, key: result.name, request: self.request, typeOfCategory: .species)
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
    
    func getSearchResultsCountFor(searchText: String?) -> Int {
        guard let result = result else { return 0 }
        guard let searchText = searchText else { return 0 }
        return result.results.filter{$0.name.lowercased().contains(searchText.lowercased())}.count
    }
    
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String? {
        guard let result = result else { return nil }
        guard let searchText = searchText else { return nil }
        let searchResults = result.results.filter{$0.name.lowercased().contains(searchText.lowercased())}
        print(result.results.filter{$0.name.lowercased().contains(searchText.lowercased())})
        print(searchResults[index].name)
        return searchResults[index].name
    }
    
    func getImage(index: Int) -> UIImage? {
        guard let result = result else { return nil }
        let data = result.results
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let result = result else { return nil }
        guard let searchText = searchText else { return nil }
        let searchResults = result.results.filter{$0.name.lowercased().contains(searchText.lowercased())}
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
    
    func setResultSelectedAt(index: Int) {
        guard let result = result else { return }
        resultSelected = result.results[index]
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
        
        let sections: [String] = [codingKeys.films.rawValue,
                                  codingKeys.people.rawValue]
        
        return sections
    }
    
    func getNumberOfSections() -> Int {
        3
    }
    
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
    
    func getSectionValuesAt(index: Int) -> [String]? {
        getSectionValuesOfSpecies(index: index)
    }
    
    private func getSectionValuesOfSpecies(index: Int) -> [String]? {
        guard let resultSelected = resultSelected else { return nil }
        switch index {
        case 1:
            return resultSelected.films
        case 2:
            return resultSelected.people
        default:
            return resultSelected.films
        }
    }
}
