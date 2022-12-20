//
//  VolumeInfo.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 18/12/22.
//

import Foundation

struct VolumeInfo: Codable, Equatable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
}
