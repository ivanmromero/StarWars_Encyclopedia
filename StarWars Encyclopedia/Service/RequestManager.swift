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
        url.host = ProcessInfo.processInfo.environment["host"]
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
    
    func getGoogleURL(searchString: String) -> URL?{
        var url = URLComponents()
        url.host = "www.googleapis.com"
        url.scheme = "https"
        
        url.path = "/customsearch/v1"
        
        url.queryItems = [
        URLQueryItem(name: "q", value: searchString),
        URLQueryItem(name: "key", value: "AIzaSyCC6X64lwICyjmfLTIRlSRqyPJybE41qcc"),
        URLQueryItem(name: "cx", value: "b387487f4c73048cc"),
        ]
        
        print(url.string)
        if let url = url.string {
            print(url)
            return URL(string: url)
        } else {
            print(serviceError.urlError)
            return nil
        }
    }
}

enum serviceError: Error {
    case urlError
    case dataError
}
