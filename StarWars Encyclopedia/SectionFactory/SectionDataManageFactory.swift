//
//  SectionDataManageFactory.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 23/01/2023.
//

import Foundation

class SectionDataManageFactory {
    static func builder(type: Categories, urls: [String], request: RequestManager, imageCacheManager: ImageCacheManager) -> SectionDataManage {
        switch type {
        case .people:
            return PeopleSection(sectionUrls: urls, request: request, imageCacheManager: imageCacheManager)
        case .films:
            return FilmSection(sectionUrls: urls, request: request, imageCacheManager: imageCacheManager)
        case .planets:
            return PlanetSection(sectionUrls: urls, request: request, imageCacheManager: imageCacheManager)
        case .species:
            return SpecieSection(sectionUrls: urls, request: request, imageCacheManager: imageCacheManager)
        case .starships:
            return StarshipSection(sectionUrls: urls, request: request, imageCacheManager: imageCacheManager)
        case .vehicles:
            return VehicleSection(sectionUrls: urls, request: request, imageCacheManager: imageCacheManager)
        }
    }
}
