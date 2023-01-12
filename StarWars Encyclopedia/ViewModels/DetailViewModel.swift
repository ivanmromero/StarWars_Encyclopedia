//
//  DetailViewModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 24/10/2022.
//

import Foundation
import UIKit

class DetailViewModel {
    var peopleResult: PeopleResult?
    var planetResult: PlanetResult?
    var speciesResult: SpeciesResult?
    var starshipResult: StarshipResult?
    var vehicleResult: VehicleResult?
    var filmResult: FilmResult?
    let categoryImage: UIImage
    
    init(result: Decodable, categoryImage: UIImage) {
        switch CategoryManager.shared.category! {
        case .people:
            self.peopleResult = result as? PeopleResult
        case .films:
            self.filmResult = result as? FilmResult
        case .planets:
            self.planetResult = result as? PlanetResult
        case .species:
            self.speciesResult = result as? SpeciesResult
        case .starships:
            self.starshipResult = result as? StarshipResult
        case .vehicles:
            self.vehicleResult = result as? VehicleResult
        }
        
        self.categoryImage = categoryImage
    }
    
    func getNumberOfSections() -> Int {
        switch CategoryManager.shared.category! {
        case .people:
            return 5
        case .films:
            return 6
        case .planets:
            return 3
        case .species:
            return 3
        case .starships:
            return 3
        case .vehicles:
            return 3
        }
    }
    
    func getNameOfSection(index: Int) -> String {
        return getRestOfSections()[index - 1]
    }
    
    func getNameOfRestOfSections() -> [String] {
        Categories.allCases.map { $0.rawValue }.filter { $0 != CategoryManager.shared.category?.rawValue }
    }
    
    func getRestOfSections() -> [String] {
        switch CategoryManager.shared.category! {
        case .people:
            return getSectionsOfPeople()
        case .films:
            return getSectionsOfFilms()
        case .planets:
            return getSectionsOfPlanets()
        case .species:
            return getSectionsOfSpecies()
        case .starships:
            return getSectionsOfStarships()
        case .vehicles:
            return getSectionsOfVehicles()
        }
    }
    
    func getSectionsOfPeople() -> [String]{
        let codingKeys = PeopleResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.films.rawValue,
                                  codingKeys.species.rawValue,
                                  codingKeys.vehicles.rawValue,
                                  codingKeys.starships.rawValue]
        
        return sections
    }
    
    func getSectionsOfFilms() -> [String]{
        let codingKeys = FilmResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.characters.rawValue,
                                  codingKeys.planets.rawValue,
                                  codingKeys.starships.rawValue,
                                  codingKeys.vehicles.rawValue,
                                  codingKeys.species.rawValue]
        return sections
    }
    
    func getSectionsOfPlanets() -> [String]{
        let codingKeys = PlanetResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.residents.rawValue,
                                  codingKeys.films.rawValue]
        
        return sections
    }
    
    func getSectionsOfSpecies() -> [String]{
        let codingKeys = SpeciesResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.films.rawValue,
                                  codingKeys.people.rawValue]
        
        return sections
    }
    
    func getSectionsOfStarships() -> [String]{
        let codingKeys = StarshipResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.pilots.rawValue,
                                  codingKeys.films.rawValue]
        
        return sections
    }
    
    func getSectionsOfVehicles() -> [String]{
        let codingKeys = VehicleResult.CodingKeys.self
        
        let sections: [String] = [codingKeys.pilots.rawValue,
                                  codingKeys.films.rawValue]
        
        return sections
    }
    
    func getPeopleInfo() -> [String: String] {
        var dictionary: [String: String] = [:]
        
        dictionary["name"] = "\(peopleResult!.name)"
        dictionary["height"] = "\(peopleResult!.height)"
        dictionary["mass"] = "\(peopleResult!.mass)"
        dictionary["hairColor"] = "\(peopleResult!.hairColor)"
        dictionary["skinColor"] = "\(peopleResult!.skinColor)"
        dictionary["eyeColor"] = "\(peopleResult!.eyeColor)"
        dictionary["birthYear"] = "\(peopleResult!.birthYear)"
        
        return dictionary
    }
    
    func getPlanetsInfo()-> [String: String] {
        let codingKeys = PlanetResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary["\(codingKeys.name.rawValue):"] = planetResult!.name
        dictionary[codingKeys.rotationPeriod.rawValue] = planetResult!.rotationPeriod
        dictionary[codingKeys.orbitalPeriod.rawValue] = planetResult!.orbitalPeriod
        dictionary[codingKeys.diameter.rawValue] = planetResult!.diameter
        dictionary[codingKeys.climate.rawValue] = planetResult!.climate
        dictionary[codingKeys.gravity.rawValue] = planetResult!.gravity
        dictionary[codingKeys.terrain.rawValue] = planetResult!.terrain
        dictionary[codingKeys.surfaceWater.rawValue] = planetResult!.surfaceWater
        
        return dictionary
    }
    
    func getFilmInfo()-> [String: String] {
        let codingKeys = FilmResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary[codingKeys.title.rawValue] = filmResult!.title
        dictionary[codingKeys.openingCrawl.rawValue] = filmResult!.openingCrawl
        dictionary[codingKeys.director.rawValue] = filmResult!.director
        dictionary[codingKeys.producer.rawValue] = filmResult!.producer
        dictionary[codingKeys.releaseDate.rawValue] = filmResult!.releaseDate
        
        return dictionary
    }
    
    func getStarshipsInfo()-> [String: String] {
        let codingKeys = StarshipResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary[codingKeys.name.rawValue] = starshipResult!.name
        dictionary[codingKeys.model.rawValue] = starshipResult!.model
        dictionary[codingKeys.manufacturer.rawValue] = starshipResult!.manufacturer
        dictionary[codingKeys.costInCredits.rawValue] = starshipResult!.costInCredits
        dictionary[codingKeys.length.rawValue] = starshipResult!.length
        dictionary[codingKeys.crew.rawValue] = starshipResult!.crew
        dictionary[codingKeys.maxAtmospheringSpeed.rawValue] = starshipResult!.maxAtmospheringSpeed
        dictionary[codingKeys.passengers.rawValue] = starshipResult!.passengers
        dictionary[codingKeys.cargoCapacity.rawValue] = starshipResult!.cargoCapacity
        dictionary[codingKeys.consumables.rawValue] = starshipResult!.consumables
        dictionary[codingKeys.hyperdriveRating.rawValue] = starshipResult!.hyperdriveRating
        dictionary[codingKeys.mglt.rawValue] = starshipResult!.mglt
        dictionary[codingKeys.starshipClass.rawValue] = starshipResult!.starshipClass
        
        return dictionary
    }
    
    //podrias hacer variables calculadas
    
    func getSpeciesInfo() -> [String: String] {
        let codingKeys = SpeciesResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary[codingKeys.name.rawValue] = speciesResult!.name
        dictionary[codingKeys.classification.rawValue] = speciesResult!.classification
        dictionary["designation:"] = speciesResult!.designation.rawValue
        dictionary[codingKeys.averageHeight.rawValue] = speciesResult!.averageHeight
        dictionary[codingKeys.skinColors.rawValue] = speciesResult!.skinColors
        dictionary[codingKeys.hairColors.rawValue] = speciesResult!.hairColors
        dictionary[codingKeys.skinColors.rawValue] = speciesResult!.eyeColors
        dictionary[codingKeys.language.rawValue] = speciesResult!.language
        dictionary[codingKeys.averageLifespan.rawValue] = speciesResult!.averageLifespan
        
        return dictionary
    }
    
    func getVehiclesInfo() -> [String: String] {
        let codingKeys = VehicleResult.CodingKeys.self
        var dictionary: [String: String] = [:]
        
        dictionary[codingKeys.name.rawValue] = vehicleResult!.name
        dictionary[codingKeys.model.rawValue] = vehicleResult!.model
        dictionary[codingKeys.manufacturer.rawValue] = vehicleResult!.manufacturer
        dictionary[codingKeys.costInCredits.rawValue] = vehicleResult!.costInCredits
        dictionary[codingKeys.length.rawValue] = vehicleResult!.length
        dictionary[codingKeys.crew.rawValue] = vehicleResult!.crew
        dictionary[codingKeys.maxAtmospheringSpeed.rawValue] = vehicleResult!.maxAtmospheringSpeed
        dictionary[codingKeys.passengers.rawValue] = vehicleResult!.passengers
        dictionary[codingKeys.cargoCapacity.rawValue] = vehicleResult!.cargoCapacity
        dictionary[codingKeys.consumables.rawValue] = vehicleResult!.consumables
        dictionary[codingKeys.vehicleClass.rawValue] = vehicleResult!.vehicleClass
        
        return dictionary
    }
    
    func getInfo() -> [String: String]{
        switch CategoryManager.shared.category! {
        case .people:
            return getPeopleInfo()
        case .films:
            return getFilmInfo()
        case .planets:
            return getPlanetsInfo()
        case .species:
            return getSpeciesInfo()
        case .starships:
            return getStarshipsInfo()
        case .vehicles:
            return getVehiclesInfo()
        }
    }
    
    func getNameOrTitle() -> String {
        switch CategoryManager.shared.category! {
        case .people:
            return peopleResult!.name
        case .films:
            return filmResult!.title
        case .planets:
            return planetResult!.name
        case .species:
            return speciesResult!.name
        case .starships:
            return starshipResult!.name
        case .vehicles:
            return vehicleResult!.name
        }
    }
    
}
