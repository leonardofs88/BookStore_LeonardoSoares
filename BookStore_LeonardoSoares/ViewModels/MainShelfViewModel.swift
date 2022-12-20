//
//  MainShelfViewModel.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 18/12/22.
//

import Foundation
import UIKit

class MainShelfViewModel: BaseViewModel {
    fileprivate var dataSource: [Book]? {
        didSet {
            if let count = dataSource?.count {
                let oddNumber = count % 2 == 0 ? 0 : 1
                self.numberOfSections = (count / 2) + oddNumber
                self.numberOfItems = count
            }
        }
    }
    
    var numberOfSections: Int = 0
    var numberOfItems: Int = 0
    

    override init(service: BookStoreService) {
        self.dataSource = []
        super.init(service: service)
    }
    
     func getBook(for indexPath: IndexPath) -> Book? {
         let index = (indexPath.section * 2) + indexPath.row
         return self.dataSource?[index]
    }
    
    func loadData(pagination: Int, hasFilter: Bool = false, block: @escaping () -> ()) {
        self.service.getShelfData(at: pagination) { [weak self] result in
            switch result {
            case .success(let books):
                if hasFilter {
                    self?.dataSource = books.filter({ $0.isFav == true })
                } else {
                    if pagination == 0 {
                        self?.dataSource = books
                    } else {
                        self?.dataSource?.append(contentsOf: books)
                    }
                }
                block()
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
     func buildViewController(for indexPath: IndexPath) -> BookDetailViewController? {
        let index = (indexPath.section * 2) + indexPath.row
        guard let book = dataSource?[index] else { return nil }
         
        let storyboard = UIStoryboard(name: "BookDetailViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController
        viewController?.viewModel = BookDetailViewModel(book: book, service: self.service)
        return viewController
    }
    
    func filterFavorites(pagination: Int, block: @escaping () -> ()) {
        self.loadData(pagination: pagination, hasFilter: true) {
            block()
        }
    }
}
