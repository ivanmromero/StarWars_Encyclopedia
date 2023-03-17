//
//  RequestManager.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 10/10/2022.
//

import Foundation

class RequestManager {
    func makeRequest<T: Decodable>(url: URL?, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(serviceError.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(serviceError.dataError))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getURL(valueCategoryPath: String, valueIdPath: String? = nil) -> URL?{
        var url = URLComponents()
        url.host = "swapi.dev"
        url.scheme = "https"
        
        if let valueIdPath = valueIdPath {
            url.path = "/api/\(valueCategoryPath)/\(valueIdPath)/"
        } else {
            url.path = "/api/\(valueCategoryPath)/"
        }
        
        if let url = url.string {
            print(url)
            return URL(string: url)
        } else {
            print(serviceError.urlError)
            return nil
        }
    }

    func getURLVisualGuide(index: Int, type: String) -> URL? {
        let urlString = "https://starwars-visualguide.com/assets/img/$type/$index.jpg"
            .replacingOccurrences(of: "$type", with: type)
            .replacingOccurrences(of: "$index", with: "\(index)")
        if let url = URL(string: urlString) {
            print(url)
            return url
        }
        return nil
    }
}

fileprivate enum serviceError: Error {
    case urlError
    case dataError
}
