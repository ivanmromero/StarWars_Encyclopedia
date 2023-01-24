//
//  CategoryDataManageFactory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation

class CategoryDataManageFactory {
    static func buildCategoryDataManage(typeCategory: Categories) -> CategoryDataManage {
        switch typeCategory {
        case .people:
            return PeopleCategory()
        case .films:
            return FilmsCategory()
        case .planets:
            return PlanetsCategory()
        case .species:
            return SpeciesCategory()
        case .starships:
            return StarshipsCategory()
        case .vehicles:
            return VehiclesCategory()
        }
    }
}
