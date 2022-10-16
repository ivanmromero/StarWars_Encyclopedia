//
//  CategoryModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 10/10/2022.
//

import Foundation

// MARK: - Welcome
struct Films: Codable {
    let results: [FilmResult]
}

// MARK: - Result
struct FilmResult: Codable {
    let title: String
    let episodeID: Int
    let openingCrawl, director, producer, releaseDate: String
    let characters, planets, starships, vehicles: [String]
    let species: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case openingCrawl = "opening_crawl"
        case director, producer
        case releaseDate = "release_date"
        case characters, planets, starships, vehicles, species, created, edited, url
    }
}
