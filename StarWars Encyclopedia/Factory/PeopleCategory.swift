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
    
    var result: People?
    var resultSelected: PeopleResult?
    
    func getResults(completion: @escaping(Bool)->Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: "people")
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<People, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.result = result
                    result.results.enumerated().forEach { (index,result) in
                        self.imageCacheManager.setImageOnCache(result.url, key: result.name, request: self.request, typeOfCategory: .people)
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
        return getSectionsOfPeople()[index - 1]
    }
    
    private func getSectionsOfPeople() -> [String]{
        let codingKeys = PeopleResult.CodingKeys.self

        let sections: [String] = [codingKeys.films.rawValue,
                                  codingKeys.species.rawValue,
                                  codingKeys.vehicles.rawValue,
                                  codingKeys.starships.rawValue]
        
        return sections
    }

    func getNumberOfSections() -> Int {
        return 5
    }
    
    func getInfoOfResultSelected() -> [String: String]? {
        getPeopleInfo()
    }
    
    private func getPeopleInfo() -> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }
        var dictionary: [String: String] = [:]
        
        dictionary["height"] = "\(resultSelected.height)"
        dictionary["mass"] = "\(resultSelected.mass)"
        dictionary["hairColor"] = "\(resultSelected.hairColor)"
        dictionary["skinColor"] = "\(resultSelected.skinColor)"
        dictionary["eyeColor"] = "\(resultSelected.eyeColor)"
        dictionary["birthYear"] = "\(resultSelected.birthYear)"
        
        return dictionary
    }
    
    func getSectionValuesAt(index: Int) -> [String]? {
        getSectionValuesOfPeople(index: index)
    }
    
    private func getSectionValuesOfPeople(index: Int) -> [String]? {
        guard let resultSelected = resultSelected else { return nil }
        switch index {
        case 1:
            return resultSelected.films
        case 2:
            return resultSelected.species
        case 3:
            return resultSelected.vehicles
        case 4:
            return resultSelected.starships
        default:
            return resultSelected.films
        }
    }
}
