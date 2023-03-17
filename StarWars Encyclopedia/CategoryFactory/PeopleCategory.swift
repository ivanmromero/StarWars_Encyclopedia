//
//  PeopleCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation
import UIKit

class PeopleCategory: CategoryDataManage {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    var nextPage: String?
    
    var peopleResults: [PeopleResult] = []
    var searchResults: [PeopleResult]?
    var resultSelected: PeopleResult?
    
    func getResults(completion: @escaping(Bool)->Void) {
        DispatchQueue(label: "com.queue.peopleSerial", qos: .userInteractive).async() {
            let dowloadGroup: DispatchGroup = DispatchGroup()
            var url: URL?
            
            if let next = self.nextPage {
                url = URL(string: next)
            } else {
                url = self.request.getURL(valueCategoryPath: "people")
            }
            
            dowloadGroup.enter()
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<People, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.peopleResults.append(contentsOf: result.results)
                    DispatchQueue.concurrentPerform(iterations: result.results.count) { index in
                        self.imageCacheManager.setImageOnCache(result.results[index].url, key: result.results[index].name, request: self.request, typeOfCategory: .people)
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
                print("Tarea de descargas de categoria people terminada")
            }
        }
    }
    
    func getResultsCount() -> Int {
        return self.peopleResults.count
    }
    
    func getNameOrTitle(index: Int) -> String {
        let data = self.peopleResults
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
        let data = self.peopleResults
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let searchResults = searchResults else { return nil }
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
    
    func setSearchResults(searchText: String) {
        self.searchResults = peopleResults.filter{$0.name.lowercased().contains(searchText.lowercased())}
    }
    
    func setResultSelectedAt(index: Int) {
        resultSelected = self.peopleResults[index]
    }
    
    func setResultSelectedForSearchAt(index: Int) {
        guard let searchResults = searchResults else { return }
        resultSelected = searchResults[index]
    }

    func getImageOfResultSelected() -> UIImage? {
        return self.imageCacheManager.imageCache.object(forKey: resultSelected!.name as AnyObject) as? UIImage
    }
    
    func getNameOrTitle() -> String {
        return resultSelected!.name
    }
    
    func getNameOfSection(index: Int) -> String {
        return getSectionsOfPeople()[index - 1]
    }
    
    private func getSectionsOfPeople() -> [String]{
        let codingKeys = PeopleResult.CodingKeys.self

        var sections: [String] = []
        
        if !(resultSelected!.films.isEmpty) {
            sections.append(codingKeys.films.rawValue)
        }
        
        if !(resultSelected!.species.isEmpty) {
            sections.append(codingKeys.species.rawValue)
        }
        
        if !(resultSelected!.vehicles.isEmpty) {
            sections.append(codingKeys.vehicles.rawValue)
        }
        
        if !(resultSelected!.starships.isEmpty) {
            sections.append(codingKeys.starships.rawValue)
        }
        
        return sections
    }

    func getNumberOfSections() -> Int { getSectionsOfPeople().count + 1 }
    
    func getInfoOfResultSelected() -> [String: String]? {
        getPeopleInfo()
    }
    
    private func getPeopleInfo() -> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = PeopleResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary["\(codingKeys.height.rawValue):"] = "\(resultSelected.height)"
        dictionary["\(codingKeys.mass.rawValue):"] = "\(resultSelected.mass)"
        dictionary["\(codingKeys.hairColor.rawValue):"] = "\(resultSelected.hairColor)"
        dictionary["\(codingKeys.skinColor.rawValue):"] = "\(resultSelected.skinColor)"
        dictionary["\(codingKeys.eyeColor.rawValue):"] = "\(resultSelected.eyeColor)"
        dictionary["\(codingKeys.birthYear.rawValue):"] = "\(resultSelected.birthYear)"
        
        return dictionary
    }
    
    func getSectionDataManageAt(_ index: Int) -> SectionDataManage? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = PeopleResult.CodingKeys.self
        var urls: [String] = []
        var type: Categories

        let section = getSectionsOfPeople()[index-1]

        switch section {
        case codingKeys.films.rawValue:
            type = .films
            urls = resultSelected.films
        case codingKeys.species.rawValue:
            type = .species
            urls = resultSelected.species
        case codingKeys.vehicles.rawValue:
            type = .vehicles
            urls = resultSelected.vehicles
        case codingKeys.starships.rawValue:
            type = .starships
            urls = resultSelected.starships
        default:
            return nil
        }
        return SectionDataManageFactory.builder(type: type, urls: urls, request: self.request, imageCacheManager: self.imageCacheManager)
    }
}
