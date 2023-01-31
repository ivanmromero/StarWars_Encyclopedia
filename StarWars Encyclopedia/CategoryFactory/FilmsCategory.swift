//
//  FilmCategory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 16/01/2023.
//

import Foundation
import UIKit

class FilmsCategory: CategoryDataManage {
    let request: RequestManager = RequestManager()
    let imageCacheManager: ImageCacheManager = ImageCacheManager()
    
    var filmResults: [FilmResult] = []
    var resultSelected: FilmResult?
    var nextPage: String?
    
    func getResults(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            var url: URL?
            
            if let next = self.nextPage {
                url = URL(string: next)
            } else {
                url = self.request.getURL(valueCategoryPath: Categories.films.rawValue)
            }
                self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Films, Error>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let result):
                        self.filmResults.append(contentsOf: result.results)
                        result.results.enumerated().forEach { (index,result) in
                            self.imageCacheManager.setImageOnCache(result.url, key: result.title, request: self.request, typeOfCategory: .films)
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
        return filmResults.count
    }
    
    func getNameOrTitle(index: Int) -> String {
        let data = filmResults
        return data[index].title
    }
    
    func getSearchResultsCountFor(searchText: String?) -> Int {
        guard let searchText = searchText else { return 0 }
        return filmResults.filter{$0.title.lowercased().contains(searchText.lowercased())}.count
    }
    
    func getNameOrTitleOfSearchResultAt(_ index: Int, searchText: String?) -> String? {
        guard let searchText = searchText else { return nil }
        let searchResults = filmResults.filter{$0.title.lowercased().contains(searchText.lowercased())}
        print(filmResults.filter{$0.title.lowercased().contains(searchText.lowercased())})
        print(searchResults[index].title)
        return searchResults[index].title
    }
    
    func getImage(index: Int) -> UIImage? {
        let data = filmResults
        return self.imageCacheManager.imageCache.object(forKey: data[index].title as AnyObject) as? UIImage
    }
    
    func getImageOfSearchResultAt(index: Int, searchText: String?) -> UIImage? {
        guard let searchText = searchText else { return nil }
        let searchResults = filmResults.filter{$0.title.lowercased().contains(searchText.lowercased())}
        return self.imageCacheManager.imageCache.object(forKey: searchResults[index].title as AnyObject) as? UIImage
    }
    
    func setResultSelectedAt(index: Int) {
        resultSelected = filmResults[index]
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
        
        var sections: [String] = []
        
        if !(resultSelected!.characters.isEmpty) {
            sections.append(codingKeys.characters.rawValue)
        }
        
        if !(resultSelected!.planets.isEmpty) {
            sections.append(codingKeys.planets.rawValue)
        }
        
        if !(resultSelected!.starships.isEmpty) {
            sections.append(codingKeys.starships.rawValue)
        }
        
        if !(resultSelected!.vehicles.isEmpty) {
            sections.append(codingKeys.vehicles.rawValue)
        }
        
        if !(resultSelected!.species.isEmpty) {
            sections.append(codingKeys.species.rawValue)
        }
        
        return sections
    }
    
    func getNumberOfSections() -> Int { getSectionsOfFilms().count + 1 }
    
    func getInfoOfResultSelected() -> [String : String]? {
        getFilmInfo()
    }
    
    private func getFilmInfo()-> [String: String]? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = FilmResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary["\(codingKeys.openingCrawl.rawValue):"] = resultSelected.openingCrawl
        dictionary["\(codingKeys.director.rawValue):"] = resultSelected.director
        dictionary["\(codingKeys.producer.rawValue):"] = resultSelected.producer
        dictionary["\(codingKeys.releaseDate.rawValue):"] = resultSelected.releaseDate
        
        return dictionary
    }
    
    func getSectionDataManageAt(_ index: Int) -> SectionDataManage? {
        guard let resultSelected = resultSelected else { return nil }
        let codingKeys = FilmResult.CodingKeys.self
        var urls: [String] = []
        var type: Categories = .films

        let section = getSectionsOfFilms()[index-1]

        switch section {
        case codingKeys.characters.rawValue:
            type = .people
            urls = resultSelected.characters
        case codingKeys.planets.rawValue:
            type = .planets
            urls = resultSelected.planets
        case codingKeys.starships.rawValue:
            type = .starships
            urls = resultSelected.starships
        case codingKeys.vehicles.rawValue:
            type = .vehicles
            urls = resultSelected.vehicles
        case codingKeys.species.rawValue:
            type = .species
            urls = resultSelected.species
        default:
            return nil
        }
        return SectionDataManageFactory.builder(type: type, urls: urls, request: self.request, imageCacheManager: self.imageCacheManager)
    }
}
