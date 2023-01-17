//
//  CacheManager.swift
//  StarWars Encyclopedia
//
//  Created by Ivan Romero on 14/01/2023.
//

import Foundation
import UIKit

class ImageCacheManager {
    let imageCache = NSCache<AnyObject,AnyObject>()
    
    func setImageOnCache(_ resultUrl: String, key: String, request: RequestManager, typeOfCategory: Categories) {
        if let id: Int =  getIntForString(resultUrl) {
            if let urlImage = request.getURLVisualGuide(index: id, type: typeOfCategory.rawValue) {
                if let image = self.transforURLtoImage(url: urlImage) {
                    self.imageCache.setObject(image, forKey: key as AnyObject)
                }
            }
        }
    }
    
    private func getIntForString(_ string: String) -> Int?{
        var number: Int? = nil
        let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let transformedString = Int(item) {
                number = transformedString
            }
        }
        return number
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
