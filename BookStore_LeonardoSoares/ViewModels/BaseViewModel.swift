//
//  BaseViewModel.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 19/12/22.
//

import Foundation
import UIKit

class BaseViewModel {
    
    public let service: BookStoreService
    
    init(service: BookStoreService) {
        self.service = service
    }
    
    internal func getImage(from URL: URL, block: @escaping (UIImage) -> () ){
        self.service.getImage(from: URL) { result in
            switch result {
            case .success(let image):
                block(image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
