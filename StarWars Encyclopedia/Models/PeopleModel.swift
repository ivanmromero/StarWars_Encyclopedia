//
//  PeopleModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 11/10/2022.
//

import Foundation

// MARK: - People
struct People: Codable {
    let count: Int
    let next: String?
    let results: [PeopleResult]
}

// MARK: - Result
struct PeopleResult: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear: String
    let gender: Gender
    let homeworld: String
    let films, species, vehicles, starships: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
    case nA = "n/a"
    case hermaphrodite = "hermaphrodite"
    case none = "none"
}
