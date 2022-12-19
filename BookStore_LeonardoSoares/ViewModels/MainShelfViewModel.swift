//
//  MainShelfViewModel.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 18/12/22.
//

import Foundation
import UIKit

class MainShelfViewModel: BaseViewModel {
    fileprivate var dataSource: [[Book]]? {
        didSet {
            if let count = dataSource?.count {
                self.numberOfSections = count / 2
            }
        }
    }
    
    fileprivate var paginationIndex: Int = 0
    internal var numberOfSections: Int = 0
    
    override init(service: BookStoreService) {
        self.dataSource = []
        super.init(service: service)
    }
    
    internal func getBook(for indexPath: IndexPath) -> Book? {
        self.dataSource?[indexPath.section][indexPath.row]
    }
    
    internal func loadData(block: @escaping () -> ()) {
        self.service.getShelfData(at: self.paginationIndex) { [weak self] result in
            switch result {
            case .success(let books):
                self?.configureShelf(books: books)
                self?.paginationIndex += 20
                block()
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    internal func buildViewController(for indexPath: IndexPath) -> BookDetailViewController? {
        guard let book = dataSource?[indexPath.section][indexPath.row] else { return nil }
        let storyboard = UIStoryboard(name: "BookDetailViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController
        viewController?.viewModel = BookDetailViewModel(book: book, service: self.service)
        return viewController
    }
    
    fileprivate func configureShelf(books: [Book]) {
        var shelf: [[Book]] = []
        var currentSectionBooks: [Book] = []
        
        books.forEach { book in
            currentSectionBooks.append(book)
            if currentSectionBooks.count == 2 {
                shelf.append(currentSectionBooks)
                currentSectionBooks = []
            }
        }
        
        self.dataSource?.append(contentsOf: shelf)
        
    }
}
