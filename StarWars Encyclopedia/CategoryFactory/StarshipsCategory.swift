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
    
    var starshipResults: [StarshipResult] = []
    var searchResults: [StarshipResult]?
    var resultSelected: StarshipResult?
    var nextPage: String?
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue(label: "com.queue.peopleSerial", qos: .userInteractive).async {
            let dowloadGroup: DispatchGroup = DispatchGroup()
            var url: URL?
            
            if let next = self.nextPage {
                url = URL(string: next)
            } else {
                url = self.request.getURL(valueCategoryPath: Categories.starships.rawValue)
            }
            
            dowloadGroup.enter()
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Starships, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.starshipResults.append(contentsOf: result.results)
                    DispatchQueue.concurrentPerform(iterations: result.results.count) { index in
                        self.imageCacheManager.setImageOnCache(result.results[index].url, key: result.results[index].name, request: self.request, typeOfCategory: .starships)
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
                print("Tarea de descargas de categoria Starships terminada")
            }
        }
    }
    
    func getResultsCount() -> Int {
        return starshipResults.count
    }
    
    func getNameOrTitle(index: Int) -> String {
        let data = starshipResults
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
        let data = starshipResults
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let searchResults = searchResults else { return nil }
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
    
    func setSearchResults(searchText: String) {
        self.searchResults = starshipResults.filter{$0.name.lowercased().contains(searchText.lowercased())}
    }
    
    func setResultSelectedAt(index: Int) {
        resultSelected = starshipResults[index]
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
