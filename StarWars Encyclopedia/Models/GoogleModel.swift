//
//  GoogleModel.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 11/10/2022.
//


import Foundation

// MARK: - GoogleModel
struct GoogleModel: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let pagemap: Pagemap?

    enum CodingKeys: String, CodingKey {
        case pagemap
    }
}

// MARK: - Pagemap
struct Pagemap: Codable {
    let cseImage: [CSEImage]?

    enum CodingKeys: String, CodingKey {
        case cseImage = "cse_image"
    }
}

// MARK: - CSEImage
struct CSEImage: Codable {
    let src: String?
}
