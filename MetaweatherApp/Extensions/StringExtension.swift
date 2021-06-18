//
//  StringExtension.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

extension String {
    func getImageUrlFromString() -> URL {
        guard let urlImage = URL(string: self) else {
            return URL(string: ApiPaths.shared.defaultImageUrl)!
        }
        return urlImage
    }
    
    func getApiUrlFromString() -> URL {
        guard let urlFromString = URL(string: self) else {
            return URL(string: "")!
        }
        return urlFromString
    }
    
}
