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
    
    var peopleResults: [PeopleResult] = []
    var resultSelected: PeopleResult?
    var nextPage: String?
    
    func getResults(completion: @escaping(Bool)->Void) {
        DispatchQueue.main.async {
            var url: URL?
            
            if let next = self.nextPage {
                url = URL(string: next)
            } else {
                url = self.request.getURL(valueCategoryPath: "people")
            }
            
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<People, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.peopleResults.append(contentsOf: result.results)
                    result.results.enumerated().forEach { (index,result) in
                        self.imageCacheManager.setImageOnCache(result.url, key: result.name, request: self.request, typeOfCategory: .people)
                    }
                    self.nextPage = result.next
                    if self.nextPage != nil {
                        self.getResults { isLoading in
                            completion(isLoading)
                        }
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    print(error)
                }
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
        guard let searchText = searchText else { return 0 }
        return self.peopleResults.filter{$0.name.lowercased().contains(searchText.lowercased())}.count
    }
    
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String? {
        guard let searchText = searchText else { return nil }
        let searchResults = self.peopleResults.filter{$0.name.lowercased().contains(searchText.lowercased())}
        print(self.peopleResults.filter{$0.name.lowercased().contains(searchText.lowercased())})
        print(searchResults[index].name)
        return searchResults[index].name
    }
    
    func getImage(index: Int) -> UIImage? {
        let data = self.peopleResults
        return self.imageCacheManager.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let searchText = searchText else { return nil }
        let searchResults = self.peopleResults.filter{$0.name.lowercased().contains(searchText.lowercased())}
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
    }
    
    func setResultSelectedAt(index: Int) {
        resultSelected = self.peopleResults[index]
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
