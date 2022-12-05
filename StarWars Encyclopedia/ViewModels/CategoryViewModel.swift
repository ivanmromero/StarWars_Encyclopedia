//
//  CategoryViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 11/10/2022.
//

import Foundation
import UIKit

class CategoryViewModel {
    private let category: Categories
    private let requestHandler: RequestHandler
    
    var searchText: String? {
        didSet {
            if searchText!.isEmpty {
                isSearching = false
            } else {
                isSearching = true
            }
        }
    }
    
    var isSearching: Bool = false
    var isLoading: Bool = true
    
    init() {
        self.requestHandler = RequestHandler()
        self.category = CategoryManager.shared.category!
    }
    
    func getData(completion: @escaping ()->Void) {
        requestHandler.getCategoryData { isTrue in
            self.isLoading = isTrue
            print(self.requestHandler.imageDictionary)
            completion()
        }
    }
    
    func getResultsCount() -> Int{
        return requestHandler.results.count
    }
    
    func getSearchResultsCount() -> Int{
        guard let searchText = searchText else { return 0 }
        switch category {
        case .people:
            let searchResults = getPeopleResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults.count
        case .films:
            let searchResults = getFilmResult().filter{$0.title.lowercased().contains(searchText.lowercased())}
            return searchResults.count
        case .planets:
            let searchResults = getPlanetResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults.count
        case .species:
            let searchResults = getSpeciesResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults.count
        case .starships:
            let searchResults = getStarshipResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults.count
        case .vehicles:
            let searchResults = getVehicleResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults.count
        }
    }
    
    func getNameOrTitle(index: Int) -> String {
        switch category {
        case .people:
            let data = getPeopleResult()
            return data[index].name
        case .films:
            let data = getFilmResult()
            return data[index].title
        case .planets:
            let data = getPlanetResult()
            return data[index].name
        case .species:
            let data = getSpeciesResult()
            return data[index].name
        case .starships:
            let data = getStarshipResult()
            return data[index].name
        case .vehicles:
            let data = getVehicleResult()
            return data[index].name
        }
    }
    
    func getImage(index: Int) -> UIImage? {
        switch category {
        case .people:
            let data = getPeopleResult()
            return requestHandler.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
        case .films:
            let data = getFilmResult()
            return requestHandler.imageCache.object(forKey: data[index].title as AnyObject) as? UIImage
        case .planets:
            let data = getPlanetResult()
            return requestHandler.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
        case .species:
            let data = getSpeciesResult()
            return requestHandler.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
        case .starships:
            let data = getStarshipResult()
            return requestHandler.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
        case .vehicles:
            let data = getVehicleResult()
            return requestHandler.imageCache.object(forKey: data[index].name as AnyObject) as? UIImage
        }
    }

    func getNameOrTitleOfSearchResult(index: Int) -> String? {
        guard let searchText = searchText else { return nil }
        switch category {
        case .people:
            let searchResults = getPeopleResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            print(getPeopleResult().filter{$0.name.lowercased().contains(searchText.lowercased())})
            print(searchResults[index].name)
            return searchResults[index].name
        case .films:
            let searchResults = getFilmResult().filter{$0.title.lowercased().contains(searchText.lowercased())}
            return searchResults[index].title
        case .planets:
            let searchResults = getPlanetResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults[index].name
        case .species:
            let searchResults = getSpeciesResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults[index].name
        case .starships:
            let searchResults = getStarshipResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults[index].name
        case .vehicles:
            let searchResults = getVehicleResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return searchResults[index].name
        }
    }
    
    func getImageOfSearchResult(index: Int) -> UIImage? {
        guard let searchText = searchText else { return nil }
        switch category {
        case .people:
            let searchResults = getPeopleResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return requestHandler.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
        case .films:
            let searchResults = getFilmResult().filter{$0.title.lowercased().contains(searchText.lowercased())}
            return requestHandler.imageCache.object(forKey: searchResults[index].title as AnyObject) as? UIImage
        case .planets:
            let searchResults = getPlanetResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return requestHandler.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
        case .species:
            let searchResults = getSpeciesResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return requestHandler.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
        case .starships:
            let searchResults = getStarshipResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return requestHandler.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
        case .vehicles:
            let searchResults = getVehicleResult().filter{$0.name.lowercased().contains(searchText.lowercased())}
            return requestHandler.imageCache.object(forKey: searchResults[index].name as AnyObject) as? UIImage
        }
    }
    
    private func getPeopleResult() -> [PeopleResult] {
        return requestHandler.results as! [PeopleResult]
    }
    
    private func getFilmResult() -> [FilmResult] {
        return requestHandler.results as! [FilmResult]
    }
    
    private func getPlanetResult() -> [PlanetResult] {
        return requestHandler.results as! [PlanetResult]
    }
    
    private func getSpeciesResult() -> [SpeciesResult] {
        return requestHandler.results as! [SpeciesResult]
    }
    
    private func getStarshipResult() -> [StarshipResult] {
        return requestHandler.results as! [StarshipResult]
    }
    
    private func getVehicleResult() -> [VehicleResult] {
        return requestHandler.results as! [VehicleResult]
    }
    
    func getResult() -> [Decodable]{
        return requestHandler.results
    }
}
