//
//  CategoriesEnums.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 08/10/2022.
//

import UIKit

enum Categories: String, CaseIterable {
    case people = "characters", films, planets, species, starships, vehicles
    
    func getCategoryImage() -> UIImage {
        switch self {
        case .people:
            return UIImage(named: "character")!
        case .films:
            return UIImage(named: "films")!
        case .planets:
            return UIImage(named: "planets")!
        case .species:
            return UIImage(named: "species")!
        case .starships:
            return UIImage(named: "starships")!
        case .vehicles:
            return UIImage(named: "vehicles")!
        }
    }
    
    func getSingularCategoriesRawValue() -> String {
        switch self {
        case .people:
            return "people"
        case .films:
            return "film"
        case .planets:
            return "planet"
        case .species:
            return "specie"
        case .starships:
            return "starship"
        case .vehicles:
            return "vehicle"
        }
    }
}
