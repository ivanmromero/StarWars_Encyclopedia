//
//  ManageDataFactory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation

class ManageDataFactory {
    static func buildManageData(typeCategory: Categories) -> ManageData {
        switch typeCategory {
        case .people:
            return PeopleCategory()
        case .films:
            return PeopleCategory()
        case .planets:
            return PeopleCategory()
        case .species:
            return PeopleCategory()
        case .starships:
            return PeopleCategory()
        case .vehicles:
            return PeopleCategory()
        }
    }
}
