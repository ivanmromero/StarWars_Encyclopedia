//
//  StarshipsCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 16/01/2023.
//

import Foundation
import UIKit

class StarshipsCategory: CategoryDataManage {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    
    var result: Starships?
    var resultSelected: StarshipResult?
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.starships.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Starships, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.result = result
                    result.results.enumerated().forEach { (index,result) in
                        self.imageCacheManager.setImageOnCache(result.url, key: result.name, request: self.request, typeOfCategory: .starships)
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
        getSectionsOfStarships()[index - 1]
    }
    
    private func getSectionsOfStarships() -> [String]{
        let codingKeys = StarshipResult.CodingKeys.self
        var sections: [String] = []
        
        if !(resultSelected!.pilots.isEmpty) {
            sections.append(codingKeys.pilots.rawValue)
        }
        
        if !(resultSelected!.films.isEmpty) {
            sections.append(codingKeys.films.rawValue)
        }
        
        return sections
    }
    
    func getNumberOfSections() -> Int { getSectionsOfStarships().count + 1 }
    
    func getInfoOfResultSelected() -> [String : String]? {
        getStarshipsInfo()
    }
    
    private func getStarshipsInfo()-> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }
        
        let codingKeys = StarshipResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary["\(codingKeys.model.rawValue):"] = resultSelected.model
        dictionary["\(codingKeys.manufacturer.rawValue):"] = resultSelected.manufacturer
        dictionary["\(codingKeys.costInCredits.rawValue):"] = resultSelected.costInCredits
        dictionary["\(codingKeys.length.rawValue):"] = resultSelected.length
        dictionary["\(codingKeys.crew.rawValue):"] = resultSelected.crew
        dictionary["\(codingKeys.maxAtmospheringSpeed.rawValue):"] = resultSelected.maxAtmospheringSpeed
        dictionary["\(codingKeys.passengers.rawValue):"] = resultSelected.passengers
        dictionary["\(codingKeys.cargoCapacity.rawValue):"] = resultSelected.cargoCapacity
        dictionary["\(codingKeys.consumables.rawValue):"] = resultSelected.consumables
        dictionary["\(codingKeys.hyperdriveRating.rawValue):"] = resultSelected.hyperdriveRating
        dictionary["\(codingKeys.mglt.rawValue):"] = resultSelected.mglt
        dictionary["\(codingKeys.starshipClass.rawValue):"] = resultSelected.starshipClass
        
        return dictionary
    }

    func getSectionDataManageAt(_ index: Int) -> SectionDataManage? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = StarshipResult.CodingKeys.self
        var urls: [String] = []
        var type: Categories
        
        let section = getSectionsOfStarships()[index-1]
        
        switch section {
        case codingKeys.pilots.rawValue:
            type = .people
            urls = resultSelected.pilots
        case codingKeys.films.rawValue:
            type = .films
            urls = resultSelected.films
        default:
            return nil
        }
        return SectionDataManageFactory.builder(type: type, urls: urls, request: self.request, imageCacheManager: self.imageCacheManager)
    }
}
