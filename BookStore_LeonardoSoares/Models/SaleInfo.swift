//
//  SaleInfo.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation

enum Saleability: String, Codable {
    case available = "FOR_SALE"
    case notAvailable = "NOT_FOR_SALE"
}

struct SaleInfo: Codable {
    let country: String
    let saleability: Saleability
    let isEbook: Bool
    let retailPrice: RetailPrice?
    let buyLink: String?
}
