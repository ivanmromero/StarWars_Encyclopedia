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
    let manageData: ManageData
    
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
        self.manageData = ManageDataFactory.buildManageData(typeCategory: self.category)
    }
    
    func getData(completion: @escaping ()->Void) {
        manageData.getResults { isTrue in
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
        return manageData.getSearchResultsCountFor(searchText: searchText)
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
        return manageData.getNameOrTitleOfSearchResultAt(index, searchText: searchText)
    }
    
    func getImageOfSearchResult(index: Int) -> UIImage? {
        guard let searchText = searchText else { return nil }
        return manageData.getImageOfSearchResultAt(index: index, searchText: searchText)
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
    
    func getResult() -> [Any]{
        return requestHandler.results
    }
}
