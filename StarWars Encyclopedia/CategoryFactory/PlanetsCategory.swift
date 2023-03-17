//
//  PlanetsCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 16/01/2023.
//

import Foundation
import UIKit

class PlanetsCategory: CategoryDataManage {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    var nextPage: String?
    
    var planetResults: [PlanetResult] = []
    var searchResults: [PlanetResult]?
    var resultSelected: PlanetResult?
    
    func getCategorySelectedRawValue() -> String {
        Categories.planets.rawValue
    }
    
    func getCategorySelectedSingularRawValue() -> String {
        Categories.planets.getSingularCategoriesRawValue()
    }
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue(label: "com.queue.peopleSerial", qos: .userInteractive).async {
            let dowloadGroup: DispatchGroup = DispatchGroup()
            var url: URL?
            
            if let next = self.nextPage {
                url = URL(string: next)
            } else {
                url = self.request.getURL(valueCategoryPath: Categories.planets.rawValue)
            }
            
            dowloadGroup.enter()
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Planets, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.planetResults.append(contentsOf: result.results)
                    DispatchQueue.concurrentPerform(iterations: result.results.count) { index in
                        self.imageCacheManager.setImageOnCache(result.results[index].url, key: result.results[index].name, request: self.request, typeOfCategory: .planets)
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
                print("Tarea de descargas de categoria planets terminada")
            }
        }
    }
    
    func getResultsCount() -> Int {
        return planetResults.count
    }
    
    func getNameOrTitle(index: Int) -> String {
        let data = planetResults
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
        let data = planetResults
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let searchResults = searchResults else { return nil }
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
    
    func setSearchResults(searchText: String) {
        self.searchResults = planetResults.filter{$0.name.lowercased().contains(searchText.lowercased())}
    }
    
    func setResultSelectedAt(index: Int) {
        resultSelected = planetResults[index]
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
        getSectionsOfPlanets()[index - 1]
    }
    
    private func getSectionsOfPlanets() -> [String]{
        let codingKeys = PlanetResult.CodingKeys.self
        
        var sections: [String] = []
        
        if !(resultSelected!.residents.isEmpty) {
            sections.append(codingKeys.residents.rawValue)
        }
        
        if !(resultSelected!.films.isEmpty) {
            sections.append(codingKeys.films.rawValue)
        }
        
        return sections
    }
    
    func getNumberOfSections() -> Int { getSectionsOfPlanets().count + 1 }
    
    func getInfoOfResultSelected() -> [String : String]? {
        getPlanetsInfo()
    }
    
    private func getPlanetsInfo()-> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }

        let codingKeys = PlanetResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary["\(codingKeys.rotationPeriod.rawValue):"] = resultSelected.rotationPeriod
        dictionary["\(codingKeys.orbitalPeriod.rawValue):"] = resultSelected.orbitalPeriod
        dictionary["\(codingKeys.diameter.rawValue):"] = resultSelected.diameter
        dictionary["\(codingKeys.climate.rawValue):"] = resultSelected.climate
        dictionary["\(codingKeys.gravity.rawValue):"] = resultSelected.gravity
        dictionary["\(codingKeys.terrain.rawValue):"] = resultSelected.terrain
        dictionary["\(codingKeys.surfaceWater.rawValue):"] = resultSelected.surfaceWater
        
        return dictionary
    }
    
    func getSectionDataManageAt(_ index: Int) -> SectionDataManage? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = PlanetResult.CodingKeys.self
        var urls: [String] = []
        var type: Categories
        
        let section = getSectionsOfPlanets()[index-1]

        switch section {
        case codingKeys.residents.rawValue:
            type = .people
            urls = resultSelected.residents
        case codingKeys.films.rawValue:
            type = .films
            urls = resultSelected.films
        default:
            return nil
        }
        return SectionDataManageFactory.builder(type: type, urls: urls, request: self.request, imageCacheManager: self.imageCacheManager)
    }
}
