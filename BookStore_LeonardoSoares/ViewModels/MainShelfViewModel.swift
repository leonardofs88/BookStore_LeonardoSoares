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
    
    fileprivate var filteredDataSource: [Book]? {
        didSet {
            if let count = filteredDataSource?.count {
                let oddNumber = count % 2 == 0 ? 0 : 1
                self.numberOfSections = (count / 2) + oddNumber
                self.numberOfItems = count
            }
        }
    }
    
    var hasFilter: Bool = false
    var numberOfSections: Int = 0
    var numberOfItems: Int = 0
    
    
    override init(service: BookStoreService) {
        self.dataSource = []
        super.init(service: service)
    }
    
    func getBook(for indexPath: IndexPath) -> Book? {
        let index = (indexPath.section * 2) + indexPath.row
        return hasFilter ? filteredDataSource?[index] : dataSource?[index]
    }
    
    func loadData(pagination: Int? = nil, block: @escaping (Error?) -> ()) {
        if let index = pagination {
            service.getShelfData(at: index) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let books):
                        if pagination == 0 {
                            self.dataSource = books
                        } else {
                            self.dataSource?.append(contentsOf: books)
                        }
                    block(nil)
                case .failure(let error):
                    block(error)
                }
            }
        } else {
            filteredDataSource = dataSource?.filter({ $0.isFav == true })
            block(nil)
        }
    }
    
    func buildViewController(for indexPath: IndexPath) -> BookDetailViewController? {
        let index = (indexPath.section * 2) + indexPath.row
        guard let book = dataSource?[index] else { return nil }
        
        let storyboard = UIStoryboard(name: "BookDetailViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController
        viewController?.viewModel = BookDetailViewModel(book: book, service: service)
        return viewController
    }
}
