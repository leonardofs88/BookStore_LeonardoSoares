//
//  Book.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation

struct Book: Codable {
    let title: String
    let authors: [String]
    let description: String
    let imageLinks: [ImageLinks]
    let shopURL: String?
    let saleInfo: SaleInfo
}
