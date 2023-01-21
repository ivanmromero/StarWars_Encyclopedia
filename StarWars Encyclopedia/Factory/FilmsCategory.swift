//
//  FilmCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 16/01/2023.
//

import Foundation
import UIKit

class FilmsCategory: ManageData {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    
    var result: Films?
    var resultSelected: FilmResult?
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.films.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Films, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.result = result
                    result.results.enumerated().forEach { (index,result) in
                        self.imageCacheManager.setImageOnCache(result.url, key: result.title, request: self.request, typeOfCategory: .films)
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
        return data[index].title
    }
    
    func getSearchResultsCountFor(searchText: String?) -> Int {
        guard let result = result else { return 0 }
        guard let searchText = searchText else { return 0 }
        return result.results.filter{$0.title.lowercased().contains(searchText.lowercased())}.count
    }
    
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String? {
        guard let result = result else { return nil }
        guard let searchText = searchText else { return nil }
        let searchResults = result.results.filter{$0.title.lowercased().contains(searchText.lowercased())}
        print(result.results.filter{$0.title.lowercased().contains(searchText.lowercased())})
        print(searchResults[index].title)
        return searchResults[index].title
    }
    
    func getImage(index: Int) -> UIImage? {
        guard let result = result else { return nil }
        let data = result.results
        return self.imageCacheManager.imageCache.object(forKey: data[index].title as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let result = result else { return nil }
        guard let searchText = searchText else { return nil }
        let searchResults = result.results.filter{$0.title.lowercased().contains(searchText.lowercased())}
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].title as AnyObject) as? UIImage
    }
    
    func setResultSelectedAt(index: Int) {
        guard let result = result else { return }
        resultSelected = result.results[index]
    }
    
    func getImageOfResultSelected() -> UIImage? {
        guard let resultSelected = resultSelected else { return nil }
        return self.imageCacheManager.imageCache.object(forKey: resultSelected.title as AnyObject) as? UIImage
    }
    
    func getNameOrTitle() -> String {
        guard let resultSelected = resultSelected else { return "No hay resultado seleccionado" }
        return resultSelected.title
    }
    
    func getNameOfSection(index: Int) -> String {
        return getSectionsOfFilms()[index - 1]
    }
    
    private func getSectionsOfFilms() -> [String]{
        let codingKeys = FilmResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.characters.rawValue,
                                  codingKeys.planets.rawValue,
                                  codingKeys.starships.rawValue,
                                  codingKeys.vehicles.rawValue,
                                  codingKeys.species.rawValue]
        return sections
    }
    
    func getNumberOfSections() -> Int { 5 }
    
    func getInfoOfResultSelected() -> [String : String]? {
        getFilmInfo()
    }
    
    private func getFilmInfo()-> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = FilmResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary[codingKeys.title.rawValue] = resultSelected.title
        dictionary[codingKeys.openingCrawl.rawValue] = resultSelected.openingCrawl
        dictionary[codingKeys.director.rawValue] = resultSelected.director
        dictionary[codingKeys.producer.rawValue] = resultSelected.producer
        dictionary[codingKeys.releaseDate.rawValue] = resultSelected.releaseDate
        
        return dictionary
    }
    
    func getSectionValuesAt(index: Int) -> [String]? {
        getSectionValuesOfFilms(index: index)
    }
    
    private func getSectionValuesOfFilms(index: Int) -> [String]? {
        guard let resultSelected = resultSelected else { return nil }
        switch index {
        case 1:
            return resultSelected.characters
        case 2:
            return resultSelected.planets
        case 3:
            return resultSelected.starships
        case 4:
            return resultSelected.vehicles
        case 5:
            return resultSelected.species
        default:
            return resultSelected.characters
        }
    }
}
