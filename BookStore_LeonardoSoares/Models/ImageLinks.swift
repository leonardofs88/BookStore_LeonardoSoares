//
//  ImageLinks.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation

struct ImageLinks: Codable, Equatable {
    let smallThumbnail: String
    let thumbnail: String
    
    var thumbnailURL: String {
        return thumbnail.replacingOccurrences(of: "http", with: "https")
    }
    
    var smalltThumbnailURL: String {
        return smallThumbnail.replacingOccurrences(of: "http", with: "https")
    }
}
