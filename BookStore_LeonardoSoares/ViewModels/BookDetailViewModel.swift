//
//  BookDetailViewModel.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 19/12/22.
//

import Foundation
import UIKit

class BookDetailViewModel: BaseViewModel {
    
    public let book: Book?
    
    init(book: Book, service: BookStoreService) {
        self.book = book
        super.init(service: service)
    }
    
    internal func loadDetails() -> Book? {
        return self.book
    }
    
}
