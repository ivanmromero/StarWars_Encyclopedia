//
//  RequestHandler.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 13/10/2022.
//

import Foundation
import UIKit

class RequestHandler {
    private let request: RequestManager = RequestManager()
    private let category = CategoryManager.shared.category
    var results: [Any] = []
    var imageDictionary: [String: UIImage] = [:]
    let imageCache = NSCache<AnyObject,AnyObject>()
    
    func getCategoryData(completion: @escaping(Bool)->Void) {
        guard let category = category else { return }
        switch category {
        case .people:
            getPeopleData { completion(false) }
        case .films:
            getFilmsData { completion(false) }
        case .planets:
            getPlanetsData { completion(false) }
        case .species:
            getSpeciesData { completion(false) }
        case .starships:
            getStarshipsData { completion(false) }
        case .vehicles:
            getVehiclesData { completion(false) }
        }
    }
    
    private func getPeopleData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: "people")
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<People, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.results = result.results
                    result.results.forEach { result in
                        self.getImageResults(searchTerm: result.name) {
                            completion()
                        }
                    }
                case .failure(let error):
                    completion()
                    print(error)
                }
            }
        }
    }
    
    private func getFilmsData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.films.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Films, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.results = result.results
                    result.results.forEach { result in
                        self.getImageResults(searchTerm: result.title) {
                            completion()
                        }
                    }
                case .failure(let error):
                    completion()
                    print(error)
                }
            }
        }
    }
    
    private func getPlanetsData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.planets.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Planets, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.results = result.results
                    result.results.forEach { result in
                        self.getImageResults(searchTerm: result.name) {
                            completion()
                        }
                    }
                case .failure(let error):
                    completion()
                    print(error)
                }
            }
        }
    }
    
    private func getSpeciesData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.species.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Species, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.results = result.results
                    result.results.forEach { result in
                        self.getImageResults(searchTerm: result.name) {
                            completion()
                        }
                    }
                case .failure(let error):
                    completion()
                    print(error)
                }
            }
        }
    }
    
    private func getVehiclesData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.vehicles.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Vehicles, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.results = result.results
                    result.results.forEach { result in
                        self.getImageResults(searchTerm: result.name) {
                            completion()
                        }
                    }
                case .failure(let error):
                    completion()
                    print(error)
                }
            }
        }
    }

    private func getStarshipsData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let url = self.request.getURL(valueCategoryPath: Categories.starships.rawValue)
            self.request.makeRequest(url: url) { [weak self] (result: Swift.Result<Starships, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.results = result.results
                    result.results.forEach { result in
                        self.getImageResults(searchTerm: result.name) {
                            completion()
                        }
                    }
                case .failure(let error):
                    completion()
                    print(error)
                }
            }
        }
    }
    
    private func getImageResults(searchTerm: String, completion: @escaping ()-> Void) {
        DispatchQueue.global().async {
            let urlImage = self.request.getGoogleURL(searchString: searchTerm)
            self.request.makeRequest(url: urlImage) { [weak self] (resultGoogle: Swift.Result<GoogleModel, Error>) in
                guard let self = self else { return }
                switch resultGoogle {
                case .success(let resultGoogle):
                    if let urlString = resultGoogle.items?.first?.pagemap?.cseImage?.first?.src {
                        if let urlImage = URL(string: urlString) {
                            if let image = self.transforURLtoImage(url: urlImage) {
//                                self.imageDictionary[searchTerm] = image
                                self.imageCache.setObject(image, forKey: searchTerm as AnyObject)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        completion()
                    }
                case .failure(let errorGoogle):
                    print(errorGoogle.localizedDescription)
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }
    
    private func transforURLtoImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
