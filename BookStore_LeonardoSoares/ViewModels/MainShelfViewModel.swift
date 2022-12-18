//
//  MainShelfViewModel.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 18/12/22.
//

import Foundation

class MainShelfViewModel {
    
    fileprivate let service: BookStoreService
    
    init(service: BookStoreService) {
        self.service = service
    }
    
    internal func loadData(block: () -> ()) {
        self.service.getShelfData(at: 0)
    }
}
