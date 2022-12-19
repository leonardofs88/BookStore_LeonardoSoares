//
//  Book.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation

struct Book: Codable {
    let volumeInfo: VolumeInfo
    let shopURL: String?
    let saleInfo: SaleInfo?
}
